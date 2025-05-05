import TDCore
import TDDomain
import UIKit

final class MyPostCoordinator: Coordinator {
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
        let fetchUserUseCase = injector.resolve(FetchUserUseCase.self)
        let fetchUserPostUseCase = injector.resolve(FetchUserPostUseCase.self)
        let myPostViewModel = MyPostViewModel(fetchUserPostUseCase: fetchUserPostUseCase, fetchUserUseCase: fetchUserUseCase)
        let myPostViewController = MyPostViewController(viewModel: myPostViewModel)
        myPostViewController.coordinator = self
        navigationController.pushTDViewController(myPostViewController, animated: true)
    }
}
