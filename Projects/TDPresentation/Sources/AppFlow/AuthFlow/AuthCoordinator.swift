import UIKit
import TDDomain
import TDCore

protocol AuthDelegate: AnyObject {
    func didMainButtonTapped() // TODO: 제거
    func didSignInButtonTapped()
    func didSignUpButtonTapped()
}

protocol AccountCoordinatorDelegate: AnyObject {
    func didFinishRegister(from coordinator: AccountCoordinator)
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
        let kakaoLoginUseCase = injector.resolve(KakaoLoginUseCase.self)
        let appleLoginUseCase = injector.resolve(AppleLoginUseCase.self)
        let viewModel = AuthViewModel(kakaoLoginUseCase: kakaoLoginUseCase, appleLoginUseCase: appleLoginUseCase)
        let signUpViewController = AuthViewController(viewModel: viewModel)
        signUpViewController.coordinator = self
        navigationController.pushViewController(signUpViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension AuthCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
        
        if childCoordinator is SignInCoordinator {
            finishDelegate?.didFinish(childCoordinator: self)
        }
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
        phoneVerificationCoordinator.accountFlowDelegate = self
        childCoordinators.append(phoneVerificationCoordinator)
        phoneVerificationCoordinator.start()
    }
}

// MARK: - Account Coordinator Delegate
extension AuthCoordinator: AccountCoordinatorDelegate {
    func didFinishRegister(from coordinator: AccountCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
