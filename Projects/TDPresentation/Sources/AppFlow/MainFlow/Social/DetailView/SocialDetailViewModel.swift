import Combine
import Foundation
import TDDomain

public final class SocialDetailViewModel: BaseViewModel {
    enum Input {
        case fetchPost
        case fetchComments
        case likePost
        case likeComment(Comment.ID)
        case registerComment(String)
        case registerImage(Data)
        case deleteRegisterImage
        case shareRoutine
        case reportPost
        case blockPost
        case blockCommet
        case didTapComment(Comment.ID)
    }
    
    enum Output {
        case post(Post)
        case comments([Comment])
        case likePost(Post)
        case likeComment(Comment)
        case createComment
        case registerImage(Data)
        case shareRoutine
        case reportPost
        case blockPost
        case blockCommet
        case didTapComment(Comment)
        case failure(String)
    }
    
    private let postID: Int
    private let fetchPostUsecase: FetchPostUseCase
    private let fetchCommentUsecase: FetchCommentUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let toggleCommentLikeUseCase: ToggleCommentLikeUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let reportPostUseCase: ReportPostUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var registerComment: Comment?
    private var registerImage: Data?
    private var currentComment: Comment? // 현재 댓글을 다려는 댓글?
    
    private(set) var post: Post?
    private(set) var comments: [Comment] = []
    
    init(
        fetchPostUsecase: FetchPostUseCase,
        fetchCommentUsecase: FetchCommentUseCase,
        togglePostLikeUseCase: TogglePostLikeUseCase,
        toggleCommentLikeUseCase: ToggleCommentLikeUseCase,
        createCommentUseCase: CreateCommentUseCase,
        reportPostUseCase: ReportPostUseCase,
        at postID: Post.ID
    ) {
        self.fetchPostUsecase = fetchPostUsecase
        self.fetchCommentUsecase = fetchCommentUsecase
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.toggleCommentLikeUseCase = toggleCommentLikeUseCase
        self.createCommentUseCase = createCommentUseCase
        self.reportPostUseCase = reportPostUseCase
        self.postID = postID
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .fetchPost:
                Task { await self.fetchPost() }
            case .fetchComments:
                Task { await self.fetchComments() }
            case .likePost:
                Task { await self.likePost() }
            case .registerComment(let content):
                Task { await self.registerComment(content: content) }
            case .registerImage(let data):
                registerImage = data
                output.send(.registerImage(data))
            case .deleteRegisterImage:
                registerImage = nil
            case .shareRoutine:
                break
            case .reportPost:
                break
            case .blockPost:
                break
            case .blockCommet:
                break
            case .likeComment(let commentID):
                Task { await self.likeComment(commentID: commentID) }
            case .didTapComment(let commentID):
                currentComment = comments.first(where: { $0.id == commentID })
                guard let comment = currentComment else { return }
                output.send(.didTapComment(comment))
            }
        
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

private extension SocialDetailViewModel {
    func fetchPost() async {
        do {
            guard let post = try await fetchPostUsecase.execute(postID: postID) else { return }
            self.post = post
            output.send(.post(post))
        } catch {
            post = nil
            output.send(.failure("글을 불러오는데 실패했습니다."))
        }
    }
    
    func fetchComments() async {
        do {
            guard let comments = try await fetchCommentUsecase.execute(postID: postID) else { return }
            self.comments = comments
            output.send(.comments(comments))
        } catch {
            comments = []
            output.send(.failure("댓글을 불러오는데 실패했습니다."))
        }
    }
    
    // MARK: - Like(Post에 대한 Like)

    private func likePost() async {
        do {
            guard var post = post else {
                output.send(.failure("게시글 정보가 없습니다."))
                return
            }
            try await togglePostLikeUseCase.execute(postID: postID, currentLike: post.isLike)
            post.toggleLike()
            self.post = post
            output.send(.likePost(post))
        } catch {
            output.send(.failure("게시글 좋아요에 실패했습니다."))
        }
    }
    
    // MARK: Reply에 대한 Like

    private func likeComment(commentID: Comment.ID) async {
        do {
            let updatedComment = try await toggleCommentLikeUseCase.execute(commentID: commentID)
            comments = comments.map { $0.id == updatedComment.id ? updatedComment : $0 }
            
            output.send(.likeComment(updatedComment))
        } catch {
            output.send(.failure("댓글 좋아요에 실패했습니다."))
        }
    }
    
    // MARK: 댓글 달기
    
    private func registerComment(content: String) async {
        let target: CommentTarget
        if let currentComment = currentComment {
             target = .comment(currentComment.id)
        } else {
             guard let post = self.post else {
                 output.send(.failure("게시글 정보가 없습니다."))
                 return
             }
             target = .post(post.id)
        }
        
        let newComment = NewComment(content: content, target: target, image: registerImage)
        do {
            let isCreated = try await createCommentUseCase.execute(newComment: newComment)
            if isCreated {
                currentComment = nil
                output.send(.createComment)
                await fetchComments()
            } else {
                output.send(.failure("댓글 작성에 실패했습니다."))
            }
        } catch {
            output.send(.failure("댓글 작성에 실패했습니다."))
        }
    }

    private func updateCommentsArray(_ comments: [Comment], withReply reply: Comment, forParentID parentID: Int) -> [Comment] {
        return comments.map { comment in
            if comment.id == parentID {
                var updatedComment = comment
                updatedComment.reply.append(reply)
                return updatedComment
            } else {
                var updatedComment = comment
                updatedComment.reply = updateCommentsArray(updatedComment.reply, withReply: reply, forParentID: parentID)
                return updatedComment
            }
        }
    }
}
