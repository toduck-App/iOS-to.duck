//
//  TabbarCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    
    lazy var tabBarController: MainTabBarController = {
        return MainTabBarController(coordinator: self)
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let items: [UINavigationController] = TabbarItem.allCases.map { createNavigationController($0) }
        configureTabBarController(items)
    }
    
    private func configureTabBarController(_ viewControllers: [UIViewController]) {
        navigationController.setNavigationBarHidden(true, animated: false)
        tabBarController.setViewControllers(viewControllers, animated: false)
        navigationController.viewControllers = [tabBarController]
    }
    
    private func createNavigationController(_ item: TabbarItem) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = item.item
        configureCoordinator(item, navController)
        return navController
    }
    
    private func configureCoordinator(_ item: TabbarItem, _ navController: UINavigationController) {
        switch item {
        case .home:
            let coordinator = HomeCoordinator(navigationController: navController)
            addCoordinator(coordinator)
        case .timer:
            let coordinator = TimerCoordinator(navigationController: navController)
            addCoordinator(coordinator)
        case .diary:
            let coordinator = DiaryCoordinator(navigationController: navController)
            addCoordinator(coordinator)
        case .social:
            let coordinator = SocialCoordinator(navigationController: navController)
            addCoordinator(coordinator)
        case .mypage:
            let coordinator = MyPageCoordinator(navigationController: navController)
            addCoordinator(coordinator)
        }
    }
    
    private func addCoordinator(_ coordinator: Coordinator) {
        coordinator.finishDelegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
        finish()
    }
}
