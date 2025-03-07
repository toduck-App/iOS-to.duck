import TDCore
import TDDomain
import UIKit

protocol SocialProfileCoordinatorDelegate: AnyObject {
    func didTapPost(id: Post.ID)
    func didTapRoutine(routine: Routine)
}

final class SocialProfileCoordinator: Coordinator, CoordinatorFinishDelegate {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    let userID: User.ID

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        id: TDDomain.User.ID
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.userID = id
    }

    func start() {
        let fetchUserDetailUseCase = injector.resolve(FetchUserDetailUseCase.self)
        let fetchUserUseCase = injector.resolve(FetchUserUseCase.self)
        let fetchUserPostUseCase = injector.resolve(FetchUserPostUseCase.self)
        let toggleUserFollowUseCase = injector.resolve(ToggleUserFollowUseCase.self)
        let fetchRoutineListUseCase = injector.resolve(FetchRoutineListUseCase.self)
        let viewModel = SocialProfileViewModel(
            id: userID,
            fetchUserDetailUseCase: fetchUserDetailUseCase,
            fetchUserUseCase: fetchUserUseCase,
            fetchUserPostUseCase: fetchUserPostUseCase,
            toggleUserFollowUseCase: toggleUserFollowUseCase,
            fetchRoutineListUseCase: fetchRoutineListUseCase
        )
        let controller = SocialProfileViewController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushTDViewController(controller, animated: true)
    }
}

extension SocialProfileCoordinator: SocialProfileCoordinatorDelegate {
    func didTapPost(id: Post.ID) {
        let coordinator = SocialDetailCoordinator(
            navigationController: navigationController,
            injector: injector,
            id: id
        )
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
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
    
    func didFinish(childCoordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
