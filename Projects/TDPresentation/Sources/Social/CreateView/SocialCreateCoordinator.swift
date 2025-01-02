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
        let fetchRoutineListUseCase = injector.resolve(FetchRoutineListUseCase.self)
        let socialAddViewModel = SocialCreateViewModel(fetchRoutineListUseCase: fetchRoutineListUseCase)
        let socialAddViewController = SocialCreateViewController(viewModel: socialAddViewModel)
        socialAddViewController.coordinator = self
        navigationController.pushTDViewController(socialAddViewController, animated: true)
    }
    
    func didCreateSocial() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
