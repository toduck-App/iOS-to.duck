import TDCore
import TDDomain
import UIKit

protocol SocialListDelegate: AnyObject {
    func didTapPost(id: Int)
}

final class SocialListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable = DIContainer.shared

    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }

    func start() {
        let fetchPostUseCase = injector.resolve(FetchPostUseCase.self)
        let togglePostLikeUseCase = injector.resolve(TogglePostLikeUseCase.self)
        let socialViewModel = SocialListViewModel(
            fetchPostUseCase: fetchPostUseCase,
            togglePostLikeUseCase: togglePostLikeUseCase
        )
        let socialViewController = SocialListViewController(viewModel: socialViewModel)
        socialViewController.coordinator = self
        navigationController.pushViewController(socialViewController, animated: false)
    }
}

extension SocialListCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

extension SocialListCoordinator: SocialListDelegate {
    func didTapPost(id: Int) {
        let socialDetailCoordinator = SocialDetailCoordinator(
            navigationController: navigationController,
            id: id
        )
        socialDetailCoordinator.finishDelegate = self
        childCoordinators.append(socialDetailCoordinator)
        socialDetailCoordinator.start()
    }
}
