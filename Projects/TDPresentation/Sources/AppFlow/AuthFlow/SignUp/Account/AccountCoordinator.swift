import UIKit
import TDDomain
import TDCore

final class AccountCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    private let phoneNumber: String
    weak var delegate: AccountCoordinatorDelegate?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        phoneNumber: String
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.phoneNumber = phoneNumber
    }

    func start() {
        let checkDuplicateUserIdUseCase = injector.resolve(CheckDuplicateUserIdUseCase.self)
        let registerUserUseCase = injector.resolve(RegisterUserUseCase.self)
        let viewModel = AccountViewModel(
            checkDuplicateUserIdUseCase: checkDuplicateUserIdUseCase,
            registerUserUseCase: registerUserUseCase,
            phoneNumber: phoneNumber
        )
        let accountViewController = AccountViewController(viewModel: viewModel)
        accountViewController.coordinator = self
        navigationController.pushTDViewController(accountViewController, animated: true)
    }
    
    func notifyRegistrationSuccess() {
        delegate?.didFinishRegister(from: self)
        self.finish(by: .popNotAnimated)
    }
}

// MARK: - Coordinator Finish Delegate
extension AccountCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
