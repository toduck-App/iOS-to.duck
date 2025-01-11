import TDCore
import TDDomain
import UIKit

final class SocialSearchCoordinator: Coordinator {
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
        let searchPostUseCase = injector.resolve(SearchPostUseCase.self)
        let searchViewModel = SocialSearchViewModel(searchPostUseCase: searchPostUseCase)
        let searchViewController = SocialSearchViewController(viewModel: searchViewModel)
        searchViewController.coordinator = self
        searchViewController.modalPresentationStyle = .fullScreen
        navigationController.pushTDViewController(searchViewController, animated: true)
    }

    func finish() {
        finishDelegate?.didFinish(childCoordinator: self)
        navigationController.popViewController(animated: true)
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
}

extension SocialSearchCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
