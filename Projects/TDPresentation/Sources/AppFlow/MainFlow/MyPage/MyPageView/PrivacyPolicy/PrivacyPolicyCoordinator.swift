import TDCore
import TDDomain
import UIKit

final class PrivacyPolicyCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start() {
        let privacyPolicyViewController = PrivacyPolicyViewController()
        privacyPolicyViewController.coordinator = self
        navigationController.pushTDViewController(privacyPolicyViewController, animated: true)
    }
}
