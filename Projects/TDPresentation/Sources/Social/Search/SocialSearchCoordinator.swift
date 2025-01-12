import TDCore
import TDDomain
import UIKit

protocol SocialSearchDelegate: AnyObject {
    func didTapPost(id: Post.ID)
    func didTapReport(id: Post.ID)
    func didTapUserProfile(id: User.ID)
}

final class SocialSearchCoordinator: Coordinator {
    weak var delegate: SocialSearchDelegate?
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
        let togglePostLikeUseCase = injector.resolve(TogglePostLikeUseCase.self)
        let blockUserUseCase = injector.resolve(BlockUserUseCase.self)
        let searchViewModel = SocialSearchViewModel(
            searchPostUseCase: searchPostUseCase,
            togglePostLikeUseCase: togglePostLikeUseCase,
            blockUserUseCase: blockUserUseCase
        )
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
        delegate?.didTapPost(id: id)
    }

    func didTapReport(id: Post.ID) {
        delegate?.didTapReport(id: id)
    }

    func didTapUserProfile(id: User.ID) {
        delegate?.didTapUserProfile(id: id)
    }
}

extension SocialSearchCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
