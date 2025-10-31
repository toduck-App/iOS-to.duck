import TDCore
import TDDomain
import UIKit

protocol SocialListDelegate: AnyObject {
    func didTapPost(postId: Post.ID, commentId: Comment.ID?)
    func didTapCreateButton()
    func didTapReport(id: Post.ID)
    func didTapUserProfile(id: User.ID)
}

final class SocialListCoordinator: Coordinator {
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
        let fetchPostUseCase = injector.resolve(FetchPostUseCase.self)
        let togglePostLikeUseCase = injector.resolve(TogglePostLikeUseCase.self)
        let blockUserUseCase = injector.resolve(BlockUserUseCase.self)
        let searchPostUseCase = injector.resolve(SearchPostUseCase.self)
        let updateRecentKeywordUseCase = injector.resolve(UpdateKeywordUseCase.self)
        let fetchRecentKeywordUseCase = injector.resolve(FetchKeywordUseCase.self)
        let deleteRecentKeywordUseCase = injector.resolve(DeleteKeywordUseCase.self)
        let deletePostUseCase = injector.resolve(DeletePostUseCase.self)
        let socialViewModel = SocialListViewModel(
            repo: injector.resolve(SocialRepository.self),
            togglePostLikeUseCase: togglePostLikeUseCase,
            blockUserUseCase: blockUserUseCase,
            updateRecentKeywordUseCase: updateRecentKeywordUseCase,
            fetchRecentKeywordUseCase: fetchRecentKeywordUseCase,
            deleteRecentKeywordUseCase: deleteRecentKeywordUseCase,
            deletePostUseCase: deletePostUseCase
        )
        let socialViewController = SocialListViewController(viewModel: socialViewModel)
        socialViewController.coordinator = self
        navigationController.pushViewController(socialViewController, animated: false)
    }
    
    func didTapHomeTomatoIcon() {
        (finishDelegate as? MainTabBarCoordinator)?.switchToHomeTab()
    }
    
    func showProfile(userId: Int) {
        let socialProfileCoordinator = SocialProfileCoordinator(
            navigationController: navigationController,
            injector: injector,
            id: userId
        )
        socialProfileCoordinator.finishDelegate = self
        childCoordinators.append(socialProfileCoordinator)
        socialProfileCoordinator.start()
    }
}

// MARK: - Coordinator Finish Delegate

extension SocialListCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Social List Delegate

extension SocialListCoordinator: SocialListDelegate {
    func didTapUserProfile(id: User.ID) {
        let socialProfileViewCoordinator = SocialProfileCoordinator(
            navigationController: navigationController,
            injector: injector,
            id: id
        )
        childCoordinators.append(socialProfileViewCoordinator)
        socialProfileViewCoordinator.finishDelegate = self
        socialProfileViewCoordinator.start()
    }

    func didTapReport(id: Post.ID) {
        let socialReportCoordinator = SocialReportCoordinator(
            navigationController: navigationController,
            injector: injector,
            postID: id
        )
        childCoordinators.append(socialReportCoordinator)
        socialReportCoordinator.finishDelegate = self
        socialReportCoordinator.start()
    }

    func didTapPost(postId: Post.ID, commentId: Comment.ID?) {
        let socialDetailCoordinator = SocialDetailCoordinator(
            navigationController: navigationController,
            injector: injector,
            postId: postId,
            commentId: commentId
        )
        socialDetailCoordinator.finishDelegate = self
        childCoordinators.append(socialDetailCoordinator)
        socialDetailCoordinator.start()
    }

    func didTapCreateButton() {
        let createCoordinator = SocialCreatorCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        createCoordinator.finishDelegate = self
        createCoordinator.delegate = self
        childCoordinators.append(createCoordinator)
        createCoordinator.start()
    }
    
    func didTapEditPost(post: Post) {
        let createCoordinator = SocialCreatorCoordinator(
            navigationController: navigationController,
            injector: injector,
            post: post
        )
        createCoordinator.finishDelegate = self
        childCoordinators.append(createCoordinator)
        createCoordinator.start()
    }
    
    func didTapRoutine(routine: Routine) {
        let coordinator = RoutineShareCoordinator(
            navigationController: navigationController,
            injector: injector,
            routine: routine
        )
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
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
}

// MARK: - Navigation Delegate

extension SocialListCoordinator: NavigationDelegate {
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(navigationController: navigationController, injector: injector)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}

extension SocialListCoordinator: SocialCreatorDelegate {
    func didFinishEventJoin() {
        navigationController.dismiss(animated: true) { [weak self] in
            if let listController = self?.navigationController.topViewController as? SocialListViewController {
                listController.showEventJoinAlert()
            }
        }
    }
}
