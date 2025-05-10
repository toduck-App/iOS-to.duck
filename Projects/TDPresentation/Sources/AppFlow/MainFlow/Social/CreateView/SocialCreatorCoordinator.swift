import TDCore
import TDDomain
import UIKit

final class SocialCreatorCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    var post: Post?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        post: Post? = nil
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.post = post
    }

    func start() {
        let createPostUseCase = injector.resolve(CreatePostUseCase.self)
        let updatePostUseCase = injector.resolve(UpdatePostUseCase.self)
        let socialCreateViewModel = SocialCreatorViewModel(createPostUseCase: createPostUseCase,
                                                          UpdatePostUseCase: updatePostUseCase,
                                                          prevPost: post)

        let socialCreatorViewController = SocialCreatorViewController(
            viewModel: socialCreateViewModel
        )
        socialCreatorViewController.post = post
        socialCreatorViewController.coordinator = self
        navigationController.pushTDViewController(socialCreatorViewController, animated: true)
    }

    func didTapDoneButton() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }

    func didTapSelectRoutineButton() {
        let coordinator = SocialSelectRoutineCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension SocialCreatorCoordinator: SocialSelectRoutineDelegate {
    func didTapRoutine(_ routine: Routine) {
        guard let socialCreatorViewController = navigationController.viewControllers.last as? SocialCreatorViewController else { return }
        socialCreatorViewController.setRoutine(routine)
    }
}
