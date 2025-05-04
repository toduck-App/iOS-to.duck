import TDCore
import TDDomain
import UIKit

final class MyBlockCoordinator: Coordinator {
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
        let fetchBlockedUsersUseCase = injector.resolve(FetchBlockedUsersUseCase.self)
        let blockUserUseCase = injector.resolve(BlockUserUseCase.self)
        let unBlockUserUseCase = injector.resolve(UnBlockUserUseCase.self)
        let myBlockViewModel = MyBlockViewModel(
            fetchBlockedUsersUseCase: fetchBlockedUsersUseCase,
            blockUserUseCase: blockUserUseCase,
            unBlockUserUseCase: unBlockUserUseCase
        )
        let myBlockViewController = MyBlockViewController(viewModel: myBlockViewModel)
        myBlockViewController.coordinator = self
        navigationController.pushTDViewController(myBlockViewController, animated: true)
    }
}
