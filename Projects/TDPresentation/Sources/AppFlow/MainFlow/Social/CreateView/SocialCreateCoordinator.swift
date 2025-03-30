import TDCore
import TDDomain
import UIKit

final class SocialCreateCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
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
        let createPostUseCase = injector.resolve(CreatePostUseCase.self)
        let socialCreateViewModel = SocialCreateViewModel(createPostUseCase: createPostUseCase)
        let socialCreateViewController = SocialCreateViewController(
            viewModel: socialCreateViewModel
        )
        socialCreateViewController.coordinator = self
        navigationController.pushTDViewController(socialCreateViewController, animated: true)
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

extension SocialCreateCoordinator: SocialSelectRoutineDelegate {
    func didTapRoutine(_ routine: Routine) {
        guard let socialCreateViewController = navigationController.viewControllers.last as? SocialCreateViewController else { return }
        socialCreateViewController.setRoutine(routine)
    }
}
