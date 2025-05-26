import TDCore
import TDDomain
import UIKit

final class WithdrawCompletionCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    var type: WithdrawReasonType
    var reason: String

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        type: WithdrawReasonType,
        reason: String
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.type = type
        self.reason = reason
    }

    func start() {
        let withdrawUseCase = injector.resolve(WithdrawUseCase.self)
        let deleteDeviceTokenUseCase = injector.resolve(DeleteDeviceTokenUseCase.self)
        let withdrawCompletionViewModel = WithdrawCompletionViewModel(
            withdrawUseCase: withdrawUseCase,
            deleteDeviceTokenUseCase: deleteDeviceTokenUseCase,
            type: type,
            reason: reason
        )
        let withdrawCompletionViewController = WithdrawCompletionViewController(viewModel: withdrawCompletionViewModel)
        withdrawCompletionViewController.hidesBottomBarWhenPushed = true
        withdrawCompletionViewController.coordinator = self
        navigationController.pushTDViewController(withdrawCompletionViewController, animated: true)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }

    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

extension WithdrawCompletionCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
