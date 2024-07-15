//
//  TabbarCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import UIKit

final class TabbarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?

    private var tabBarController: MainTabBarController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        tabBarController = MainTabBarController(coordinator: self)
        navigationController.setViewControllers([tabBarController!], animated: false)
    }
}
