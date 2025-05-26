import TDCore
import TDDomain
import UIKit

final class WithdrawReasonInputCoordinator: Coordinator {
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
        let withdrawReasonInputViewController = WithdrawReasonInputViewController()
        withdrawReasonInputViewController.hidesBottomBarWhenPushed = true
        withdrawReasonInputViewController.coordinator = self
        navigationController.pushTDViewController(withdrawReasonInputViewController, animated: true)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

extension WithdrawReasonInputCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

extension WithdrawReasonInputCoordinator {
    func didTapNextButton(type: WithdrawReasonType, reason: String) {
        let withdrawCompletionCoordinator = WithdrawCompletionCoordinator(
            navigationController: navigationController,
            injector: injector,
            type: type,
            reason: reason
        )
        withdrawCompletionCoordinator.finishDelegate = self
        childCoordinators.append(withdrawCompletionCoordinator)
        withdrawCompletionCoordinator.start()
    }
}
