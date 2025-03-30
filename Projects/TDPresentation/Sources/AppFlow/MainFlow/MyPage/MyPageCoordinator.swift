//
//  MyPageCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import UIKit
import TDCore
import TDDomain

final class MyPageCoordinator: Coordinator {
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
        let fetchUserNicknameUseCase = injector.resolve(FetchUserNicknameUseCase.self)
        let viewModel = MyPageViewModel(fetchUserNicknameUseCase: fetchUserNicknameUseCase)
        let myPageViewController = MyPageViewController(viewModel: viewModel)
        myPageViewController.coordinator = self
        navigationController.pushViewController(myPageViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension MyPageCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Navigation Delegate
extension MyPageCoordinator: NavigationDelegate {
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(navigationController: navigationController, injector: injector)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
    
    func didTapProfileButton() {
        let editProfileMenuCoordinator = EditProfileMenuCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        editProfileMenuCoordinator.finishDelegate = self
        childCoordinators.append(editProfileMenuCoordinator)
        editProfileMenuCoordinator.start()
    }
}
