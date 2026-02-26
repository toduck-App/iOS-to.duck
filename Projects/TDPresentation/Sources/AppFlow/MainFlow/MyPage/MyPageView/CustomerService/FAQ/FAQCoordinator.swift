import TDCore
import TDDomain
import UIKit

final class FAQCoordinator: Coordinator {
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
        let faqViewController = FAQViewController()
        faqViewController.coordinator = self
        navigationController.pushTDViewController(faqViewController, animated: true)
    }
}
