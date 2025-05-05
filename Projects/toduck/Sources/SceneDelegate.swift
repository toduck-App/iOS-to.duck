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
    var appCoordinator: Coordinator?
    let navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let injector: DependencyResolvable = DIContainer.shared
        assembleDependencies()
        setupTabBarAppearance()
        appCoordinator = AppCoordinator(navigationController: navigationController, injector: injector)
        appCoordinator?.start()
        
        window?.rootViewController = navigationController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
            if url.scheme == "toduck", url.host == "profile" {
                guard let userId = url.queryParameters?["userId"] else { return }
            }
        }
    }
    
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
}
