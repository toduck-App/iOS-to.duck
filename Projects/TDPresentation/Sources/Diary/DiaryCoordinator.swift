//
//  DiaryCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit
import TDCore

final class DiaryCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
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
        let diaryViewController = DiaryViewController()
        navigationController.pushViewController(diaryViewController, animated: false)
    }
}
