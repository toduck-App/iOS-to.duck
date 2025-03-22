import TDCore
import TDDomain
import TDNetwork
import UIKit

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
        observeTokenExpired()
        Task {
            do {
                try await TDTokenManager.shared.loadTokenFromKC()
                let authRepository = injector.resolve(AuthRepository.self)
                try await authRepository.refreshToken()
                await MainActor.run {
                    TDTokenManager.shared.accessToken == nil ? startAuthFlow() : startTabBarFlow()
                }
            } catch {
                await MainActor.run {
                    startAuthFlow()
                }
            }
        }
    }
    
    private func observeTokenExpired() {
        NotificationCenter.default.addObserver(
            forName: .userRefreshTokenExpired,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.childCoordinators.removeAll()
            self?.navigationController.popToRootViewController(animated: true)
            self?.startAuthFlow()
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
        let signUpCoordinator = AuthCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        signUpCoordinator.start()
        childCoordinators.append(signUpCoordinator)
    }
}
