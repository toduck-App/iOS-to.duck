//
//  MainTabBarController.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    private weak var coordinator: TabbarCoordinator?
    
    init(coordinator: TabbarCoordinator? = nil) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
    }
    
    private func setupTabBar() {
        let viewControllers = TabbarItem.allCases.map { item -> UINavigationController in
            let viewController = UIViewController() // 각 탭에 해당하는 뷰 컨트롤러를 생성
            viewController.tabBarItem = item.item
            return UINavigationController(rootViewController: viewController)
        }
        
        self.viewControllers = viewControllers
    }
}
