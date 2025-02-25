import UIKit
import TDCore

protocol AuthDelegate: AnyObject {
    func didSignUpButtonTapped()
}

final class AuthCoordinator: Coordinator {
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
        let signUpViewController = AuthViewController()
        signUpViewController.coordinator = self
        navigationController.pushViewController(signUpViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension AuthCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

extension AuthCoordinator: AuthDelegate {
    func didSignUpButtonTapped() {
        let phoneVerificationCoordinator = PhoneVerificationCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        phoneVerificationCoordinator.finishDelegate = self
        childCoordinators.append(phoneVerificationCoordinator)
        phoneVerificationCoordinator.start()
    }
}
