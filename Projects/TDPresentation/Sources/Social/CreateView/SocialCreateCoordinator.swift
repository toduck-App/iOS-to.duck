import TDCore
import TDDomain
import UIKit

final class SocialCreateCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable = DIContainer.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let socialAddViewModel = SocialCreateViewModel()
        let socialAddViewController = SocialCreateViewController(viewModel: socialAddViewModel)
        socialAddViewController.coordinator = self
        navigationController.pushTDViewController(socialAddViewController, animated: true)
    }
}
