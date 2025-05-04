import TDCore
import TDDomain
import UIKit

final class NotifByFunctionCoordinator: Coordinator {
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
        let notifByFunctionViewController = NotifByFunctionViewController()
        notifByFunctionViewController.coordinator = self
        navigationController.pushTDViewController(notifByFunctionViewController, animated: true)
    }
}
