import TDCore
import TDDomain
import UIKit

final class MyCommentCoordinator: Coordinator {
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
        let fetchCommentUseCase = injector.resolve(FetchCommentUseCase.self)
        let myCommentViewModel = MyCommentViewModel(fetchUserUseCase: fetchUserUseCase, fetchCommentUseCase: fetchCommentUseCase)
        let myCommentViewController = MyCommentViewController(viewModel: myCommentViewModel)
        myCommentViewController.coordinator = self
        navigationController.pushTDViewController(myCommentViewController, animated: true)
    }
}
