import UIKit
import TDDomain
import TDCore

protocol SignInDelegate: AnyObject {
    func didFindAccount()
    func didSignIn()
}

final class SignInCoordinator: Coordinator {
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
        let loginUseCase = injector.resolve(LoginUseCase.self)
        let signInViewModel = SignInViewModel(loginUseCase: loginUseCase)
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewController.coordinator = self
        navigationController.pushTDViewController(signInViewController, animated: true)
    }
}

// MARK: - Coordinator Finish Delegate
extension SignInCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - SignIn Delegate
extension SignInCoordinator: SignInDelegate {
    func didFindAccount() {
        let findAccountCoordinator = FindAccountCoordinator(navigationController: navigationController, injector: injector)
        findAccountCoordinator.finishDelegate = self
        childCoordinators.append(findAccountCoordinator)
        findAccountCoordinator.start()
    }
    
    func didSignIn() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController, injector: injector)
        mainTabBarCoordinator.finishDelegate = self
        childCoordinators = [mainTabBarCoordinator]
        mainTabBarCoordinator.start()
    }
}
