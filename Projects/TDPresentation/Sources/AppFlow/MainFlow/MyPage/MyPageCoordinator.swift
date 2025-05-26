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
        let deleteDeviceTokenUseCase = injector.resolve(DeleteDeviceTokenUseCase.self)
        let viewModel = MyPageViewModel(
            fetchUserNicknameUseCase: fetchUserNicknameUseCase,
            fetchUserDetailUseCase: fetchUserDetailUseCase,
            userLogoutUseCase: userLogoutUseCase,
            deleteDeviceTokenUseCase: deleteDeviceTokenUseCase
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
    
    func didTapAlarmButton() {
        let notificationCoordinator = NotificationCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        notificationCoordinator.finishDelegate = self
        childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
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

    func didTapProfileButton(nickName: String, imageUrl: String?) {
        let editProfileCoordinator = EditProfileCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        editProfileCoordinator.finishDelegate = self
        childCoordinators.append(editProfileCoordinator)
        editProfileCoordinator.start(nickName: nickName, imageUrl: imageUrl)
        // MARK: 회원 정보 수정 은 추후에 구현
//        let editProfileMenuCoordinator = EditProfileMenuCoordinator(
//            navigationController: navigationController,
//            injector: injector
//        )
//        editProfileMenuCoordinator.finishDelegate = self
//        childCoordinators.append(editProfileMenuCoordinator)
//        editProfileMenuCoordinator.start()
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
        let notificationSettingCoordinator = NotificationSettingCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        notificationSettingCoordinator.finishDelegate = self
        childCoordinators.append(notificationSettingCoordinator)
        notificationSettingCoordinator.start()
    }

    func didTapPostManagement() {
        let myPostCoordinator = MyPostCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        myPostCoordinator.finishDelegate = self
        childCoordinators.append(myPostCoordinator)
        myPostCoordinator.start()
    }

    func didTapMyComments() {
        let myCommentCoordinator = MyCommentCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        myCommentCoordinator.finishDelegate = self
        childCoordinators.append(myCommentCoordinator)
        myCommentCoordinator.start()
    }

    func didTapBlockManagement() {
        let myBlockCoordinator = MyBlockCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        myBlockCoordinator.finishDelegate = self
        childCoordinators.append(myBlockCoordinator)
        myBlockCoordinator.start()
    }

    func didTapTermsOfUse() {
        let termOfUseCoordinator = TermOfUseCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        termOfUseCoordinator.finishDelegate = self
        childCoordinators.append(termOfUseCoordinator)
        termOfUseCoordinator.start()
    }

    func didTapPrivacyPolicy() {
        let privacyPolicyCoordinator = PrivacyPolicyCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        privacyPolicyCoordinator.finishDelegate = self
        childCoordinators.append(privacyPolicyCoordinator)
        privacyPolicyCoordinator.start()
    }
}
