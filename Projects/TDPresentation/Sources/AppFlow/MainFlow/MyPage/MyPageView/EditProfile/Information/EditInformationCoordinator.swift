import TDCore
import UIKit

final class EditInformationCoordinator: Coordinator {
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
        let editInformationViewController = EditInformationViewController()
        editInformationViewController.hidesBottomBarWhenPushed = true
        editInformationViewController.coordinator = self
        navigationController.pushTDViewController(editInformationViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
