import UIKit
import TDCore
import TDDomain

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
        let requestPhoneVerificationCodeUseCase = injector.resolve(RequestPhoneVerificationCodeUseCase.self)
        let verifyPhoneCodeUseCase = injector.resolve(VerifyPhoneCodeUseCase.self)
        let viewModel = PhoneVerificationViewModel(
            requestPhoneVerificationCodeUseCase: requestPhoneVerificationCodeUseCase,
            verifyPhoneCodeUseCase: verifyPhoneCodeUseCase
        )
        let phoneVerificationViewController = PhoneVerificationViewController(viewModel: viewModel)
        phoneVerificationViewController.coordinator = self
        navigationController.pushTDViewController(phoneVerificationViewController, animated: true)
    }
    
    func startAccountViewCoordinator() {
        let accountViewCoordinator = AccountCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        childCoordinators.append(accountViewCoordinator)
        accountViewCoordinator.start()
    }
}

// MARK: - Coordinator Finish Delegate
extension PhoneVerificationCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
