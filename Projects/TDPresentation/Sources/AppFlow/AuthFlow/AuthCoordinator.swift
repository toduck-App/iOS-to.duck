import UIKit
import TDCore

protocol AuthDelegate: AnyObject {
    func didMainButtonTapped() // TODO: 제거
    func didSignInButtonTapped()
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
        let viewModel = AuthViewModel()
        let signUpViewController = AuthViewController(viewModel: viewModel)
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

// MARK: - SignUp Delegate
extension AuthCoordinator: AuthDelegate {
    func didMainButtonTapped() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController, injector: injector)
        mainTabBarCoordinator.finishDelegate = self
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    func didSignInButtonTapped() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController, injector: injector)
        signInCoordinator.finishDelegate = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start()
    }
    
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
