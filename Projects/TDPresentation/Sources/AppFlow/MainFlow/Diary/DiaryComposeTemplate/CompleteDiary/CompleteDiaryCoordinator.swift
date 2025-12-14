import UIKit
import TDDomain
import TDDesign
import TDCore

final class CompleteDiaryCoordinator: Coordinator {
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
        let fetchStreakUseCase = injector.resolve(FetchStreakUseCase.self)
        let vm = CompleteDiaryViewModel(fetchDiaryStreakUseCase: fetchStreakUseCase)
        let vc = CompleteDiaryViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushTDViewController(vc, animated: true)
    }
}
