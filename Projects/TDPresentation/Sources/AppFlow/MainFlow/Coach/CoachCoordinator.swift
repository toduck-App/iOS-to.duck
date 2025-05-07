import TDCore
import TDDomain
import UIKit

public final class CoachCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishDelegate: CoordinatorFinishDelegate?
    public var injector: DependencyResolvable
    private var splashViewController: SplashViewController?
    
    public init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    public func start() {
        let coachViewViewController = CoachViewViewController()
        coachViewViewController.coordinator = self
        navigationController.setViewControllers([coachViewViewController], animated: false)
    }
}
