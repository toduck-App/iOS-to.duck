//
//  AppCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit
    
final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabbarCoordinator = TabbarCoordinator(navigationController: navigationController)
        tabbarCoordinator.start()
        childCoordinators.append(tabbarCoordinator)
    }
}
