import TDCore
import TDDomain
import UIKit

final class ToduckCalendarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable = DIContainer.shared

    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }

    func start() {
        let fetchScheduleListUseCase = injector.resolve(FetchScheduleListUseCase.self)
        let toduckCalendarViewModel = ToduckCalendarViewModel(fetchScheduleListUseCase: fetchScheduleListUseCase)
        let toduckCalendarViewController = ToduckCalendarViewController(viewModel: toduckCalendarViewModel)
        toduckCalendarViewController.coordinator = self
        navigationController.pushViewController(toduckCalendarViewController, animated: true)
    }
}

extension ToduckCalendarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
