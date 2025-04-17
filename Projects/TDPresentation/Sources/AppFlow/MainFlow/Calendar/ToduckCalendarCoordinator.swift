import TDCore
import TDDomain
import UIKit

final class ToduckCalendarCoordinator: Coordinator {
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
        let fetchScheduleListUseCase = injector.resolve(FetchScheduleListUseCase.self)
        let finishScheduleUseCase = DIContainer.shared.resolve(FinishScheduleUseCase.self)
        let finishRoutineUseCase = DIContainer.shared.resolve(FinishRoutineUseCase.self)
        let toduckCalendarViewModel = ToduckCalendarViewModel(
            fetchScheduleListUseCase: fetchScheduleListUseCase,
            finishScheduleUseCase: finishScheduleUseCase,
            finishRoutineUseCase: finishRoutineUseCase
        )
        let toduckCalendarViewController = ToduckCalendarViewController(viewModel: toduckCalendarViewModel)
        toduckCalendarViewController.coordinator = self
        navigationController.pushTDViewController(toduckCalendarViewController, animated: true)
    }
}

extension ToduckCalendarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
