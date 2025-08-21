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
        let fetchScheduleListUseCase = injector.resolve(FetchServerScheduleListUseCase.self)
        let finishScheduleUseCase = DIContainer.shared.resolve(FinishScheduleUseCase.self)
        let deleteScheduleUseCase = injector.resolve(DeleteScheduleUseCase.self)
        let toduckCalendarViewModel = ToduckCalendarViewModel(
            fetchScheduleListUseCase: fetchScheduleListUseCase,
            finishScheduleUseCase: finishScheduleUseCase,
            deleteScheduleUseCase: deleteScheduleUseCase
        )
        let toduckCalendarViewController = ToduckCalendarViewController(viewModel: toduckCalendarViewModel)
        toduckCalendarViewController.coordinator = self
        navigationController.pushTDViewController(toduckCalendarViewController, animated: true)
    }
    
    func didTapTodoMakor(
        mode: TDTodoMode,
        selectedDate: Date?,
        preTodo: (any TodoItem)?,
        delegate: TodoCreatorCoordinatorDelegate?
    ) {
        guard let selectedDate else { return }
        let eventMakorCoordinator = TodoCreatorCoordinator(
            navigationController: navigationController,
            injector: injector,
            selectedDate: selectedDate
        )
        eventMakorCoordinator.finishDelegate = self
        eventMakorCoordinator.delegate = delegate
        childCoordinators.append(eventMakorCoordinator)
        eventMakorCoordinator.start(mode: mode, preEvent: preTodo)
    }
}

extension ToduckCalendarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
