import TDCore
import TDDomain
import UIKit

final class MyBlockCoordinator: Coordinator {
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
        let myBlockViewController = MyBlockViewController()
        myBlockViewController.coordinator = self
        navigationController.pushTDViewController(myBlockViewController, animated: true)
    }
}
