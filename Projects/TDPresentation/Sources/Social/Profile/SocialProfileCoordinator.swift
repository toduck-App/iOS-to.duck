import TDCore
import TDDomain
import UIKit

protocol SocialProfileCoordinatorDelegate: AnyObject {
    func didTapPost(id: Post.ID)
}

final class SocialProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable = DIContainer.shared
    let userID: User.ID

    init(navigationController: UINavigationController, id: TDDomain.User.ID) {
        self.navigationController = navigationController
        self.userID = id
    }

    func start() {
        let fetchUserDetailUseCase = injector.resolve(FetchUserDetailUseCase.self)
        let fetchUserUseCase = injector.resolve(FetchUserUseCase.self)
        let fetchUserPostUseCase = injector.resolve(FetchUserPostUseCase.self)
        let viewModel = SocialProfileViewModel(
            id: userID,
            fetchUserDetailUseCase: fetchUserDetailUseCase,
            fetchUserUseCase: fetchUserUseCase,
            fetchUserPostUseCase: fetchUserPostUseCase
        )
        let controller = SocialProfileViewController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension SocialProfileCoordinator: SocialProfileCoordinatorDelegate {
    func didTapPost(id: Post.ID) {
        let coordinator = SocialDetailCoordinator(navigationController: navigationController, id: id)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
