import TDCore
import TDDomain
import UIKit

final class NotificationSettingCoordinator: Coordinator, CoordinatorFinishDelegate {
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
        let notificationSettingViewController = NotificationSettingViewController()
        notificationSettingViewController.coordinator = self
        navigationController.pushTDViewController(notificationSettingViewController, animated: true)
    }
    
    func didTapNotificationByFunction() {
        let notifByFunctionCoordinator = NotifByFunctionCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        notifByFunctionCoordinator.finishDelegate = self
        childCoordinators.append(notifByFunctionCoordinator)
        notifByFunctionCoordinator.start()
    }
    
    func didFinish(childCoordinator: any Coordinator) {
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
