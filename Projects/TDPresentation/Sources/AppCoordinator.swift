import UIKit
import TDCore

public final class AppCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishDelegate: CoordinatorFinishDelegate?
    public var injector: DependencyResolvable
    
    public init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    public func start() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, injector: injector)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}
