import Combine
import Foundation
import TDDomain

public final class SocialDetailViewModel: BaseViewModel {
    enum Input {
        case fetchPost
        case fetchComments
        case likePost
        case likeComment(Comment.ID)
        case createComment
        case shareRoutine
        case reportPost
        case blockPost
        case blockCommet
    }
    
    enum Output {
        case post(Post)
        case comments([Comment])
        case likePost(Post)
        case likeComment(Comment)
        case createComment(Comment)
        case shareRoutine
        case reportPost
        case blockPost
        case blockCommet
        case failure(String)
    }
    
    private let postID: UUID
    private let fetchPostUsecase: FetchPostUseCase
    private let fetchCommentUsecase: FetchCommentUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let toggleCommentLikeUseCase: ToggleCommentLikeUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let reportPostUseCase: ReportPostUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
            case .createComment:
                break
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
            post = try await togglePostLikeUseCase.execute(postID: postID)
            guard let post else {
                output.send(.failure("게시글 좋아요에 실패했습니다."))
                return
            }
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
}
