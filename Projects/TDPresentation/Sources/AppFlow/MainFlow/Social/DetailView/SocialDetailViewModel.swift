import Combine
import Foundation
import TDDomain

public final class SocialDetailViewModel: BaseViewModel {
    enum Input {
        case fetchPost
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
            let result = try await fetchPostUsecase.execute(postID: postID)
            post = result.post
            comments = result.comments
            output.send(.post(result.post))
            output.send(.comments(result.comments))
        } catch {
            post = nil
            comments = []
            output.send(.failure("글을 불러오는데 실패했습니다."))
        }
    }
    
    // MARK: - Like(Post에 대한 Like)

    private func likePost() async {
        do {
            guard var post else {
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
        do {
            let image: (fileName: String, imageData: Data)? = registerImage != nil ? (fileName: "\(UUID().uuidString).jpg", imageData: registerImage!) : nil
            try await createCommentUseCase.execute(postID: postID, parentId: currentComment?.id, content: content, image: image)
            
            currentComment = nil
            output.send(.createComment)
            await fetchPost()
        } catch {
            output.send(.failure("댓글 등록에 실패했습니다."))
        }
    }
}
