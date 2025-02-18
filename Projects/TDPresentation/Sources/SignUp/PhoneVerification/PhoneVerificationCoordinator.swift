import UIKit
import TDCore

final class PhoneVerificationCoordinator: Coordinator {
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
        let phoneVerificationViewController = PhoneVerificationViewController()
        phoneVerificationViewController.coordinator = self
        navigationController.pushTDViewController(phoneVerificationViewController, animated: true)
    }
}

// MARK: - Coordinator Finish Delegate
extension PhoneVerificationCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
