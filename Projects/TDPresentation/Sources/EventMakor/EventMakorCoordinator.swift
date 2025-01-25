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
        let createScheduleUseCase = injector.resolve(CreateScheduleUseCase.self)
        let fetchRoutineListUseCase = injector.resolve(FetchCategoriesUseCase.self)
        let viewModel = EventMakorViewModel(
            createScheduleUseCase: createScheduleUseCase,
            fetchCategoriesUseCase: fetchRoutineListUseCase
        )
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
            categoryCoordinator.delegate = self
            categoryCoordinator.start()
        case .date:
            let dateCoordinator = SheetCalendarCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            dateCoordinator.finishDelegate = self
            dateCoordinator.delegate = self
            dateCoordinator.start()
        case .time:
            let timeCoordinator = SheetTimeCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            timeCoordinator.finishDelegate = self
            timeCoordinator.delegate = self
            timeCoordinator.start()
        }
    }
}

extension EventMakorCoordinator: SheetColorDelegate {
    func didSaveCategory() {
        guard let eventMakorViewController = navigationController.viewControllers.last as? EventMakorViewController else { return }
        eventMakorViewController.reloadCategoryView()
    }
}

extension EventMakorCoordinator: SheetCalendarDelegate {
    func didTapSaveButton(startDate: Date, endDate: Date?) {
        guard let eventMakorViewController = navigationController.viewControllers.last as? EventMakorViewController else { return }
        eventMakorViewController.updateSelectedDate(startDate: startDate, endDate: endDate)
    }
}

extension EventMakorCoordinator: SheetTimeDelegate {
    func didTapSaveButton(
        isAllDay: Bool,
        isAM: Bool,
        hour: Int,
        minute: Int
    ) {
        guard let eventMakorViewController = navigationController.viewControllers.last as? EventMakorViewController else { return }
        eventMakorViewController.updateSelectedTime(
            isAllDay: isAllDay,
            isAM: isAM,
            hour: hour,
            minute: minute
        )
    }
}
