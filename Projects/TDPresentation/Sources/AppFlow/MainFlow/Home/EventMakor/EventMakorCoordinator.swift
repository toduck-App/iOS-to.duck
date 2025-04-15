import UIKit
import TDDomain
import TDDesign
import TDCore

final class EventMakorCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    private let selectedDate: Date

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        selectedDate: Date
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.selectedDate = selectedDate
    }
    
    func start(mode: EventMakorViewController.Mode, preEvent: (any EventPresentable)?) {
        let createScheduleUseCase = injector.resolve(CreateScheduleUseCase.self)
        let createRoutineUseCase = injector.resolve(CreateRoutineUseCase.self)
        let fetchRoutineListUseCase = injector.resolve(FetchCategoriesUseCase.self)
        let updateScheduleUseCase = injector.resolve(UpdateScheduleUseCase.self)
        let viewModel = EventMakorViewModel(
            mode: mode,
            createScheduleUseCase: createScheduleUseCase,
            createRoutineUseCase: createRoutineUseCase,
            fetchCategoriesUseCase: fetchRoutineListUseCase,
            updateScheduleUseCase: updateScheduleUseCase,
            preEvent: preEvent
        )
        viewModel.setupInitialDate(with: selectedDate)
        let eventMakorViewController = EventMakorViewController(mode: mode, isEdit: preEvent != nil, viewModel: viewModel)
        eventMakorViewController.coordinator = self
        eventMakorViewController.hidesBottomBarWhenPushed = true
        eventMakorViewController.updateSelectedDate(startDate: selectedDate, endDate: nil)
        navigationController.pushTDViewController(eventMakorViewController, animated: true)
        if let preEvent {
            eventMakorViewController.updatePreEvent(preEvent: preEvent)
        }
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
        var selectedCoordinator: Coordinator?
        switch type {
        case .category:
            let categoryCoordinator = SheetColorCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            categoryCoordinator.finishDelegate = self
            categoryCoordinator.delegate = self
            categoryCoordinator.start()
            selectedCoordinator = categoryCoordinator
        case .date:
            let dateCoordinator = SheetCalendarCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            dateCoordinator.finishDelegate = self
            dateCoordinator.delegate = self
            dateCoordinator.start()
            selectedCoordinator = dateCoordinator
        case .time:
            let timeCoordinator = SheetTimeCoordinator(
                navigationController: navigationController,
                injector: injector
            )
            timeCoordinator.finishDelegate = self
            timeCoordinator.delegate = self
            timeCoordinator.start()
            selectedCoordinator = timeCoordinator
        default: break
        }
        
        if let selectedCoordinator = selectedCoordinator {
            childCoordinators.append(selectedCoordinator)
        }
    }
}

// MARK: - Sheet Delegate
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
