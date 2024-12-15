import Foundation
import Combine
import TDDomain

public final class SocialDetailViewModel: BaseViewModel {
    enum Input {
        case fetchPost
        case fetchComments
        case likePost
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
        case createComment(Comment)
        case shareRoutine
        case reportPost
        case blockPost
        case blockCommet
        case failure(String)
    }
    
    private let postID: Int
    private let fetchPostUsecase: FetchPostUseCase
    private let fetchCommentUsecase: FetchCommentUseCase
    private let likePostUseCase: TogglePostLikeUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let reportPostUseCase: ReportPostUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private let output = PassthroughSubject<Output, Never>()
    
    
    private(set) var post: Post?
    private(set) var comments: [Comment] = []
    
    init(
        fetchPostUsecase: FetchPostUseCase,
        fetchCommentUsecase: FetchCommentUseCase,
        likePostUseCase: TogglePostLikeUseCase,
        createCommentUseCase: CreateCommentUseCase,
        reportPostUseCase: ReportPostUseCase,
        at postID: Int
    ) {
        self.fetchPostUsecase = fetchPostUsecase
        self.fetchCommentUsecase = fetchCommentUsecase
        self.likePostUseCase = likePostUseCase
        self.createCommentUseCase = createCommentUseCase
        self.reportPostUseCase = reportPostUseCase
        self.postID = postID
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchPost:
                self?.fetchPost()
            case .fetchComments:
                self?.fetchComments()
            case .likePost:
                break
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
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

private extension SocialDetailViewModel {
    func fetchPost() {
        Task {
            do {
                guard let post = try await fetchPostUsecase.execute(postId: postID) else { return }
                self.post = post
                output.send(.post(post))
            } catch {
                self.post = nil
                output.send(.failure("글을 불러오는데 실패했습니다."))
            }
        }
    }
    
    func fetchComments() {
        Task {
            do {
                guard let comments = try await fetchCommentUsecase.execute(postID: postID) else { return }
                self.comments = comments
                output.send(.comments(comments))
            } catch {
                self.comments = []
                output.send(.failure("댓글을 불러오는데 실패했습니다."))
            }
        }
    }
}

extension SocialDetailViewModel {
    enum Action {}
}
