import TDCore
import TDDomain
import UIKit

final class SocialDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable = DIContainer.shared

    let postID: Int
    
    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.postID = id
        setNavigationBar()
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
        navigationController.pushViewController(socialDetailViewController, animated: true)
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
    }
}
