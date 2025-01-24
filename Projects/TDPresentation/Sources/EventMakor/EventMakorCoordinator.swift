import UIKit
import TDDomain
import TDDesign
import TDCore

final class EventMakorCoordinator: Coordinator {
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

    func start(mode: ScheduleAndRoutineViewController.Mode) {
        let fetchRoutineListUseCase = injector.resolve(FetchCategoriesUseCase.self)
        let viewModel = EventMakorViewModel(fetchCategoriesUseCase: fetchRoutineListUseCase)
        let eventMakorViewController = EventMakorViewController(mode: mode, viewModel: viewModel)
        eventMakorViewController.coordinator = self
        navigationController.pushTDViewController(eventMakorViewController, animated: true)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension EventMakorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - TDFormMoveView Delegate
extension EventMakorCoordinator: TDFormMoveViewDelegate {
    func didTapMoveView(_ view: TDDesign.TDFormMoveView, type: TDDesign.TDFormMoveViewType) {
        switch type {
        case .category:
            let categoryCoordinator = SheetColorCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            categoryCoordinator.finishDelegate = self
            categoryCoordinator.start()
        case .date:
            let dateCoordinator = SheetCalendarCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            dateCoordinator.finishDelegate = self
            dateCoordinator.start()
        case .time:
            let timeCoordinator = SheetTimeCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            timeCoordinator.finishDelegate = self
            timeCoordinator.start()
        }
    }
}
