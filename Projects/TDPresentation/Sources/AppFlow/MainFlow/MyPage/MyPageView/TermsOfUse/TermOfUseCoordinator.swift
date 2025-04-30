import TDCore
import TDDomain
import UIKit

final class TermOfUseCoordinator: Coordinator {
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
        let termOfUseViewController = TermOfUseViewController()
        termOfUseViewController.coordinator = self
        navigationController.pushTDViewController(termOfUseViewController, animated: false)
    }
}
