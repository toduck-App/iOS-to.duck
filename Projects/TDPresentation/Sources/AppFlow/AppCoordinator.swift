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
    private var pendingDeepLink: DeepLinkType?
    private var pendingFCMToken: String?
    
    public init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    public func start() {
        showSplash()
        observeFCMToken()
        
        if !TDTokenManager.shared.isFirstLaunch {
            TDTokenManager.shared.launchFirstLaunch()
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
                        processPendingDeepLink()
                        registerPendingFCMToken()
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
    
    private func startTabBarFlow(completion: (() -> Void)? = nil) {
        let tabBarCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        tabBarCoordinator.start()
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        completion?()
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
    
    // MARK: – DeepLink helpers
    
    public func handleDeepLink(_ link: DeepLinkType) {
        guard TDTokenManager.shared.accessToken != nil else {
            pendingDeepLink = link
            if !childCoordinators.contains(where: { $0 is AuthCoordinator }) {
                startAuthFlow()
            }
            return
        }
        
        guard let tabBarCoordinator = childCoordinators.first(where: { $0 is MainTabBarCoordinator }) as? MainTabBarCoordinator else {
            pendingDeepLink = link
            startTabBarFlow { [weak self] in
                self?.handleDeepLink(link)
            }
            return
        }
        
        tabBarCoordinator.handleDeepLink(link)
    }

    func processPendingDeepLink() {
        guard let pending = pendingDeepLink else { return }
        handleDeepLink(pending)
        pendingDeepLink = nil
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
    
    // MARK: Notification Helpers
    private func observeFCMToken() {
        NotificationCenter.default.addObserver(
            forName: .didReceiveFCMToken,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            guard let token = notification.userInfo?["token"] as? String else { return }

            if TDTokenManager.shared.accessToken == nil {
                TDLogger.info("🔒 accessToken 없음. FCM 토큰 보류: \(token)")
                pendingFCMToken = token
            } else {
                sendFCMTokenToServer(token)
            }
        }
    }
    
    private func registerPendingFCMToken() {
        guard let token = pendingFCMToken else { return }
        sendFCMTokenToServer(token)
        pendingFCMToken = nil
    }
    
    private func sendFCMTokenToServer(_ token: String) {
        let useCase = injector.resolve(RegisterDeviceTokenUseCase.self)
        Task {
            do {
                TDLogger.info("✅ FCM 토큰 서버 등록 시도: \(token)")
                try await useCase.execute(token: token)
            } catch {
                TDLogger.error("❌ FCM 토큰 서버 등록 실패: \(error)")
            }
        }
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
        registerPendingFCMToken()
    }
}
