import UIKit

final class SocialCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let socialViewController = SocialViewController()
        navigationController.pushViewController(socialViewController, animated: false)
    }
}
