import UIKit
import TDCore

protocol SignUpDelegate: AnyObject {
    func didSignInButtonTapped(_ signUpViewController: SignUpViewController)
    func didSignUpButtonTapped(_ signUpViewController: SignUpViewController)
}

final class SignUpCoordinator: Coordinator {
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
        let signUpViewController = SignUpViewController()
        signUpViewController.coordinator = self
        navigationController.pushViewController(signUpViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension SignUpCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - SignUp Delegate
extension SignUpCoordinator: SignUpDelegate {
    func didSignInButtonTapped(_ signUpViewController: SignUpViewController) {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController, injector: injector)
        signInCoordinator.finishDelegate = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start()
    }
    
    func didSignUpButtonTapped(_ signUpViewController: SignUpViewController) {
        
    }
}
