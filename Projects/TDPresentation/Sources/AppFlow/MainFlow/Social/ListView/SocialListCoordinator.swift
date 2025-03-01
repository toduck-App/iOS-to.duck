import TDCore
import TDDomain
import UIKit

protocol SocialListDelegate: AnyObject {
    func didTapPost(id: Post.ID)
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
        let socialViewModel = SocialListViewModel(
            fetchPostUseCase: fetchPostUseCase,
            togglePostLikeUseCase: togglePostLikeUseCase,
            blockUserUseCase: blockUserUseCase,
            searchPostUseCase: searchPostUseCase,
            updateRecentKeywordUseCase: updateRecentKeywordUseCase,
            fetchRecentKeywordUseCase: fetchRecentKeywordUseCase,
            deleteRecentKeywordUseCase: deleteRecentKeywordUseCase
        )
        let socialViewController = SocialListViewController(viewModel: socialViewModel)
        socialViewController.coordinator = self
        navigationController.pushViewController(socialViewController, animated: false)
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
            id: id
        )
        childCoordinators.append(socialReportCoordinator)
        socialReportCoordinator.finishDelegate = self
        socialReportCoordinator.start()
    }

    func didTapPost(id: Post.ID) {
        let socialDetailCoordinator = SocialDetailCoordinator(
            navigationController: navigationController,
            injector: injector,
            id: id
        )
        socialDetailCoordinator.finishDelegate = self
        childCoordinators.append(socialDetailCoordinator)
        socialDetailCoordinator.start()
    }

    func didTapCreateButton() {
        let createCoordinator = SocialCreateCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        createCoordinator.finishDelegate = self
        childCoordinators.append(createCoordinator)
        createCoordinator.start()
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
