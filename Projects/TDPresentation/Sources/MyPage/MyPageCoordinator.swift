//
//  MyPageCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import UIKit
import TDCore

final class MyPageCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let myPageViewController = MyPageViewController()
        navigationController.pushViewController(myPageViewController, animated: false)
    }
}
