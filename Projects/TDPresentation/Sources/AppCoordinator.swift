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
            startSignUpFlow()
        }
    }
    
    private func startTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    private func startSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        signUpCoordinator.start()
        childCoordinators.append(signUpCoordinator)
    }
}
