import Foundation
import TDDomain

public final class SocialDetailViewModel: BaseViewModel {
    private let postID: Int
    private let fetchPostUsecase: FetchPostUseCase
    private let likePostUseCase: TogglePostLikeUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let reportPostUseCase: ReportPostUseCase
    
    @Published private(set) var post: Post?
    @Published private(set) var comments: [Comment] = []
    
    init(
        fetchPostUsecase: FetchPostUseCase,
        likePostUseCase: TogglePostLikeUseCase,
        createCommentUseCase: CreateCommentUseCase,
        reportPostUseCase: ReportPostUseCase,
        at postID: Int
    ) {
        self.fetchPostUsecase = fetchPostUsecase
        self.likePostUseCase = likePostUseCase
        self.createCommentUseCase = createCommentUseCase
        self.reportPostUseCase = reportPostUseCase
        self.postID = postID
    }
    
    func action(
        _ action: Action
    ) {
        switch action {
        case .fetchPost:
            fetchPost()
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
    }
}

private extension SocialDetailViewModel {
    func fetchPost() {
        Task {
            do {
                guard let post = try await fetchPostUsecase.execute(postId: postID) else { return }
                self.post = post
            } catch (let error) {
                self.post = nil
            }
        }
    }
}

extension SocialDetailViewModel {
    enum Action {
        case fetchPost
        case likePost
        case createComment
        case shareRoutine
        case reportPost
        case blockPost
        case blockCommet
    }
}
