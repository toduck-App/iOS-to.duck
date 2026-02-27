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

    func didTapInquiry() {
        let inquiryCoordinator = InquiryCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        inquiryCoordinator.finishDelegate = self
        childCoordinators.append(inquiryCoordinator)
        inquiryCoordinator.start()
    }
}

// MARK: - Coordinator Finish Delegate

extension FAQCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
