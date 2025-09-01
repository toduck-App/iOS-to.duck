import UIKit
import TDDomain
import TDCore

protocol AuthDelegate: AnyObject {
    func didSignInButtonTapped()
    func didSignUpButtonTapped()
}

protocol RegisterSuccessCoordinatorDelegate: AnyObject {
    func didFinishRegister(from coordinator: RegisterSuccessCoordinator)
}

protocol AuthCoordinatorDelegate: AnyObject {
    func didLogin()
}

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var delegate: AuthCoordinatorDelegate?

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
    
    func didLogin() {
        finishDelegate?.didFinish(childCoordinator: self)
        delegate?.didLogin()
        (finishDelegate as? AppCoordinator)?.processPendingDeepLink()
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
        phoneVerificationCoordinator.delegate = self
        childCoordinators.append(phoneVerificationCoordinator)
        phoneVerificationCoordinator.start()
    }
}

// MARK: - Account Coordinator Delegate
extension AuthCoordinator: RegisterSuccessCoordinatorDelegate {
    func didFinishRegister(from coordinator: RegisterSuccessCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
