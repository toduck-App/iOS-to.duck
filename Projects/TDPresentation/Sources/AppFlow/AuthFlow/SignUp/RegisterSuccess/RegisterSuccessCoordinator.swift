import UIKit
import TDDomain
import TDCore

final class RegisterSuccessCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var delegate: RegisterSuccessCoordinatorDelegate?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let registerSuccessViewController = RegisterSuccessViewController()
        registerSuccessViewController.coordinator = self
        navigationController.pushTDViewController(registerSuccessViewController, animated: true)
    }
    
    func notifyRegistrationSuccess() {
        self.finish(by: .popNotAnimated)
        delegate?.didFinishRegister(from: self)
    }
}

// MARK: - Coordinator Finish Delegate
extension RegisterSuccessCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
