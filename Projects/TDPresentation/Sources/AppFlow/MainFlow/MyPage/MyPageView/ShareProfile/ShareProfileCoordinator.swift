
import UIKit
import TDCore

final class ShareProfileCoordinator: Coordinator {
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
        let shareProfileViewController = ShareProfileViewController()
        shareProfileViewController.coordinator = self
        navigationController.pushTDViewController(shareProfileViewController, animated: true)
    }
}
