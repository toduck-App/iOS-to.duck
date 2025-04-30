//
//  MyPageCoordinator.swift
//  toduck
//
//  Created by 박효준 on 7/16/24.
//

import TDCore
import TDDomain
import UIKit

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
        let userLogoutUseCase = injector.resolve(UserLogoutUseCase.self)
        let fetchUserDetailUseCase = injector.resolve(FetchUserUseCase.self)
        let viewModel = MyPageViewModel(
            fetchUserNicknameUseCase: fetchUserNicknameUseCase,
            fetchUserDetailUseCase: fetchUserDetailUseCase,
            userLogoutUseCase: userLogoutUseCase
        )
        let myPageViewController = MyPageViewController(viewModel: viewModel)
        myPageViewController.coordinator = self
        navigationController.pushTDViewController(myPageViewController, animated: false)
    }

    func didTapWithdrawButton() {
        let withdrawCoordinator = WithdrawCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        withdrawCoordinator.finishDelegate = self
        childCoordinators.append(withdrawCoordinator)
        withdrawCoordinator.start()
    }

    func didTapLogoutButton() {
        finishDelegate?.didFinish(childCoordinator: self)
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
    
    func didTapShareProfile() {
        let shareProfileCoordinator = ShareProfileCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        shareProfileCoordinator.finishDelegate = self
        childCoordinators.append(shareProfileCoordinator)
        shareProfileCoordinator.start()
    }

    func didTapNotificationSettings() {
        print("Notification Settings Tapped")
    }

    func didTapPostManagement() {
        print("Post Management Tapped")
    }

    func didTapMyComments() {
        print("My Comments Tapped")
    }

    func didTapBlockManagement() {
        print("Block Management Tapped")
    }

    func didTapTermsOfUse() {
        print("Terms of Use Tapped")
    }

    func didTapPrivacyPolicy() {
        print("Privacy Policy Tapped")
    }
}
