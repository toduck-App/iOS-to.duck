//
//  SceneDelegate.swift
//  toduck
//
//  Created by 승재 on 5/21/24.
//

import TDCore
import TDData
import TDDomain
import Swinject
import TDPresentation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: (any Coordinator)?
    let navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let injector: DependencyResolvable = DIContainer.shared
        assembleDependencies()
        appCoordinator = AppCoordinator(navigationController: navigationController, injector: injector)
        appCoordinator?.start()
        
        window?.rootViewController = navigationController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
    
    private func assembleDependencies() {
        DIContainer.shared.assemble([DataAssembly(), DomainAssembly()])
    }
}
