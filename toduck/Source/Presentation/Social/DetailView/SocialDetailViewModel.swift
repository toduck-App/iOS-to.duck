import Foundation

public final class SocialDetailViewModel: BaseViewModel {
    
    private var fetchPostUsecase: FetchPostUseCase
    private var likePostUseCase: TogglePostLikeUseCase
    private var createCommentUseCase: CreateCommentUseCase
    private var reportPostUseCase: ReportPostUseCase
    
    private var postID: Int
    
    init(fetchPostUsecase: FetchPostUseCase,
                likePostUseCase: TogglePostLikeUseCase,
                createCommentUseCase: CreateCommentUseCase,
                reportPostUseCase: ReportPostUseCase,
                at postID: Int) {
        self.fetchPostUsecase = fetchPostUsecase
        self.likePostUseCase = likePostUseCase
        self.createCommentUseCase = createCommentUseCase
        self.reportPostUseCase = reportPostUseCase
        self.postID = postID
    }
    
    
    func action(_ action: Action) {
        switch action {
        case .fetchPost:
            break
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
