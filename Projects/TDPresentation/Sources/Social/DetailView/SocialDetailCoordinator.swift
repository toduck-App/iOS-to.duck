import TDCore
import TDDomain
import UIKit

final class SocialDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    let postID: Post.ID
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        id: Post.ID
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.postID = id
    }

    func start() {
        let fetchPostUseCase = injector.resolve(FetchPostUseCase.self)
        let likePostUseCase = injector.resolve(TogglePostLikeUseCase.self)
        let fetchCommentUseCase = injector.resolve(FetchCommentUseCase.self)
        let createCommentUseCase =  injector.resolve(CreateCommentUseCase.self)
        let reportPostUseCase = injector.resolve(ReportPostUseCase.self)
        
        let socialDetailViewModel = SocialDetailViewModel(
            fetchPostUsecase: fetchPostUseCase,
            fetchCommentUsecase: fetchCommentUseCase,
            likePostUseCase: likePostUseCase,
            createCommentUseCase: createCommentUseCase,
            reportPostUseCase: reportPostUseCase,
            at: postID
        )
        
        let socialDetailViewController = SocialDetailViewController(
            viewModel: socialDetailViewModel
        )
        socialDetailViewController.coordinator = self
        navigationController.pushTDViewController(socialDetailViewController, animated: true)
    }
}
