import KakaoSDKAuth
import Swinject
import TDCore
import TDData
import TDDomain
import TDNetwork
import TDPresentation
import TDStorage
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let navigationController = UINavigationController()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        assembleDependencies()
        setupTabBarAppearance()
        setupNotification()
        
        let injector: DependencyResolvable = DIContainer.shared
        appCoordinator = AppCoordinator(navigationController: navigationController, injector: injector)
        appCoordinator?.start()

        // URL Scheme 처리
        if let urlContext = connectionOptions.urlContexts.first {
            handleDeepLink(url: urlContext.url)
        }

        // Universal Link 처리
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let webpageURL = userActivity.webpageURL {
            handleUniversalLink(url: webpageURL)
        }
    }
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url: url)
    }

    // MARK: - Universal Links

    func scene(
        _ scene: UIScene,
        continue userActivity: NSUserActivity
    ) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let webpageURL = userActivity.webpageURL else {
            return
        }

        handleUniversalLink(url: webpageURL)
    }
    
    private func handleUniversalLink(url: URL) {
        // Universal Link 형식: https://toduck.app/_ul/*
        guard url.host == "toduck.app",
              url.path.hasPrefix("/_ul/") else {
            return
        }

        // /_ul/ 이후 경로 추출
        let pathWithoutPrefix = String(url.path.dropFirst(5)) // "/_ul/" 제거

        // toduck:// 스킴으로 변환
        var components = URLComponents()
        components.scheme = "toduck"
        components.host = pathWithoutPrefix.components(separatedBy: "?").first
        components.query = url.query

        guard let customSchemeURL = components.url else { return }
        handleDeepLink(url: customSchemeURL)
    }

    private func handleDeepLink(url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
            return
        }

        guard let deepLink = DeepLinkType(url: url) else { return }
        appCoordinator?.handleDeepLink(deepLink)
    }
    
    // MARK: - Setup
    
    private func assembleDependencies() {
        DIContainer.shared.assemble([ServiceAssembly(), StorageAssembly(), DataAssembly(), DomainAssembly()])
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotificationDeepLink(_:)),
            name: .didReceivePushNotificationURL,
            object: nil
        )
    }
    
    @objc
    private func handleNotificationDeepLink(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let url = userInfo["url"] as? URL
        else { return }
        
        handleDeepLink(url: url)
    }
}
