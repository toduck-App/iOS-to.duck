import TDCore
import TDDomain
import UIKit

final class InquiryCoordinator: Coordinator {
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
        let viewModel = InquiryViewModel()
        let inquiryViewController = InquiryViewController(viewModel: viewModel)
        inquiryViewController.coordinator = self
        navigationController.pushTDViewController(inquiryViewController, animated: true)
    }
}
