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
        diaryViewController.coordinator = self
        navigationController.pushViewController(diaryViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension DiaryCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Navigation Delegate
extension DiaryCoordinator: NavigationDelegate {
    func didTapAlarmButton() {
        // TODO: 알람 페이지로 이동
        TDLogger.debug("알람 페이지로 이동")
    }
    
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(navigationController: navigationController, injector: injector)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}
