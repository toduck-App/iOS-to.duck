import UIKit

final class SocialCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = PostRepositoryImpl()
        let fetchPostUseCase = FetchPostUseCaseImpl(repository: repository)
        let socialViewModel = SocialViewModel(useCase: fetchPostUseCase)
        let socialViewController = SocialViewController(viewModel: socialViewModel)
        navigationController.pushViewController(socialViewController, animated: false)
    }
}
