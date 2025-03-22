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
        if let _ = UserDefaults.standard.string(forKey: "USER_NAME") {
            startTabBarFlow()
        } else {
            startAuthFlow()
        }
    }
    
    private func startTabBarFlow() {
        let tabBarCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    private func startAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        authCoordinator.start()
        authCoordinator.finishDelegate = self
        childCoordinators.append(authCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    public func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }

        if childCoordinator is AuthCoordinator {
            startTabBarFlow()
        }
    }
}
