import TDCore
import TDDomain
import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func didLogin()
}

public final class AppCoordinator: Coordinator {
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
        showSplash()
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            startWalkThroughFlow()
            removeSplash()
            return
        }
        startDefaultFlow()
    }
    
    private func startDefaultFlow() {
        observeTokenExpired()
        
        Task {
            do {
                try await TDTokenManager.shared.loadTokenFromKC()
                let authRepository = injector.resolve(AuthRepository.self)
                try await authRepository.refreshToken()
                
                await MainActor.run {
                    removeSplash()
                    if TDTokenManager.shared.accessToken == nil {
                        startAuthFlow()
                    } else {
                        startTabBarFlow()
                    }
                }
            } catch {
                await MainActor.run {
                    removeSplash()
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
            if let currentViewController = self?.navigationController.topViewController as? ErrorAlertDisplayable {
                currentViewController.showErrorAlert(errorMessage: "재로그인이 필요합니다.")
            }
            self?.startAuthFlow()
        }
    }
    
    private func startWalkThroughFlow() {
        let walkThroughCoordinator = WalkThroughCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        walkThroughCoordinator.start()
        walkThroughCoordinator.finishDelegate = self
        childCoordinators.append(walkThroughCoordinator)
    }
    
    private func startTabBarFlow() {
        let tabBarCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        tabBarCoordinator.start()
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
    }
    
    private func startAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        authCoordinator.start()
        authCoordinator.finishDelegate = self
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
    }
    
    // MARK: – Skeleton helpers

    private func showSplash() {
        let splashViewController = SplashViewController()
        self.splashViewController = splashViewController
        navigationController.setViewControllers([splashViewController], animated: false)
    }

    private func removeSplash() {
        guard let splashViewController else { return }
        if navigationController.viewControllers.first === splashViewController {
            navigationController.viewControllers.removeFirst()
        }
        self.splashViewController = nil
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    public func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
        
        if childCoordinator is WalkThroughCoordinator {
            navigationController.popToRootViewController(animated: true)
            startAuthFlow()
        }

        if childCoordinator is AuthCoordinator {
            startTabBarFlow()
        } else if childCoordinator is MainTabBarCoordinator {
            navigationController.popToRootViewController(animated: true)
            startAuthFlow()
        }
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didLogin() {
        childCoordinators.removeAll { $0 is AuthCoordinator }
        startTabBarFlow()
    }
}
