import TDCore
import TDDomain
import UIKit

public final class AppCoordinator: Coordinator {
    // MARK: - Properties
    
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishDelegate: CoordinatorFinishDelegate?
    public var injector: DependencyResolvable
    
    private var splashViewController: SplashViewController?
    private var pendingDeepLink: DeepLinkType?
    private var pendingFCMToken: String?
    
    // MARK: - Initializer
    
    public init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    // MARK: - Coordinator Lifecycle
    
    public func start() {
        showSplash()
        observeFCMToken()
        observeTokenExpired()
        
        if !TDTokenManager.shared.isFirstLaunch {
            TDTokenManager.shared.launchFirstLaunch()
            startWalkThroughFlow()
            removeSplash()
            startWalkThroughFlow()
            return
        }
        
        startDefaultFlow()
    }
    
    // MARK: - Flow Management
    
    private func startDefaultFlow() {
        Task {
            do {
                try await TDTokenManager.shared.loadTokenFromKC()
                
                await MainActor.run {
                    removeSplash()
                    if TDTokenManager.shared.accessToken == nil {
                        startAuthFlow()
                    } else {
                        startTabBarFlow()
                        fetchStreakData()
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
    
    // MARK: - Notification & Observer Setup
    
    private func observeTokenExpired() {
        NotificationCenter.default.addObserver(
            forName: .userRefreshTokenExpired,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.childCoordinators.removeAll()
            self.navigationController.popToRootViewController(animated: true)
            if let currentViewController = self.navigationController.topViewController as? ErrorAlertDisplayable {
                currentViewController.showErrorAlert(errorMessage: "재로그인이 필요합니다.")
            }
            self.startAuthFlow()
        }
    }
    
    private func observeFCMToken() {
        NotificationCenter.default.addObserver(
            forName: .didReceiveFCMToken,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let token = notification.userInfo?["token"] as? String else { return }
            
            if TDTokenManager.shared.accessToken == nil {
                TDLogger.info("🔒 accessToken 없음. FCM 토큰 보류: \(token)")
                self?.pendingFCMToken = token
            } else {
                self?.sendFCMTokenToServer(token)
            }
        }
    }
    
    // MARK: - Push Notification (FCM) Helpers
    
    private func registerPendingFCMToken() {
        guard let token = pendingFCMToken else { return }
        sendFCMTokenToServer(token)
        pendingFCMToken = nil
    }
    
    private func sendFCMTokenToServer(_ token: String) {
        let registerDeviceTokenUseCase = injector.resolve(RegisterDeviceTokenUseCase.self)
        Task {
            do {
                TDLogger.info("✅ FCM 토큰 서버 등록 시도: \(token)")
                try await registerDeviceTokenUseCase.execute(token: token)
                TDLogger.info("✅ FCM 토큰 서버 등록 성공")
            } catch {
                TDLogger.error("❌ FCM 토큰 서버 등록 실패: \(error)")
                self.pendingFCMToken = token
            }
        }
    }
    
    // MARK: - DeepLink Helpers
    
    public func handleDeepLink(_ link: DeepLinkType) {
        if TDTokenManager.shared.accessToken == nil {
            pendingDeepLink = link
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
    
    // MARK: - UI Helpers
    
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
    
    private func fetchStreakData() {
        let fetchStreakUseCase = injector.resolve(FetchStreakUseCase.self)
        Task {
            try await fetchStreakUseCase.execute()
        }
    }
}

// MARK: - CoordinatorFinishDelegate

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

// MARK: - AuthCoordinatorDelegate

extension AppCoordinator: AuthCoordinatorDelegate {
    func didLogin() {
        childCoordinators.removeAll { $0 is AuthCoordinator }
        startTabBarFlow()
        registerPendingFCMToken()
        processPendingDeepLink()
    }
}
