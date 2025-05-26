import UIKit
import TDDomain
import TDDesign
import TDCore

protocol TodoCreatorCoordinatorDelegate: AnyObject {
    func didTapSaveButton(createdDate: Date)
}

final class TodoCreatorCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    private let selectedDate: Date
    weak var delegate: TodoCreatorCoordinatorDelegate?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        selectedDate: Date
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.selectedDate = selectedDate
    }
    
    func start(mode: TDTodoMode, preEvent: (any TodoItem)?) {
        let createScheduleUseCase = injector.resolve(CreateScheduleUseCase.self)
        let createRoutineUseCase = injector.resolve(CreateRoutineUseCase.self)
        let fetchRoutineListUseCase = injector.resolve(FetchCategoriesUseCase.self)
        let updateScheduleUseCase = injector.resolve(UpdateScheduleUseCase.self)
        let updateRoutineUseCase = injector.resolve(UpdateRoutineUseCase.self)
        let viewModel = TodoCreatorViewModel(
            mode: mode,
            createScheduleUseCase: createScheduleUseCase,
            createRoutineUseCase: createRoutineUseCase,
            fetchCategoriesUseCase: fetchRoutineListUseCase,
            updateScheduleUseCase: updateScheduleUseCase,
            updateRoutineUseCase: updateRoutineUseCase,
            preEvent: preEvent,
            selectedDate: selectedDate
        )
        viewModel.setupInitialDate(with: selectedDate, isEditMode: preEvent != nil)
        let todoCreatorViewController = TodoCreatorViewController(mode: mode, isEdit: preEvent != nil, viewModel: viewModel)
        todoCreatorViewController.coordinator = self
        todoCreatorViewController.hidesBottomBarWhenPushed = true
        todoCreatorViewController.updateSelectedDate(startDate: selectedDate, endDate: nil)
        todoCreatorViewController.delegate = delegate
        navigationController.pushTDViewController(todoCreatorViewController, animated: true)
        if let preEvent {
            todoCreatorViewController.updatePreEvent(preEvent: preEvent, selectedDate: selectedDate)
        }
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension TodoCreatorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - TDFormMoveView Delegate
extension TodoCreatorCoordinator: TDFormMoveViewDelegate {
    func didTapMoveView(_ view: TDFormMoveView, type: TDFormMoveViewType) {
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

extension TodoCreatorCoordinator: SheetColorDelegate {
    func didSaveCategory() {
        guard let eventMakorViewController = navigationController.viewControllers.last as? TodoCreatorViewController else { return }
        eventMakorViewController.reloadCategoryView()
    }
}

extension TodoCreatorCoordinator: SheetCalendarDelegate {
    func didTapSaveButton(startDate: Date, endDate: Date?) {
        guard let eventMakorViewController = navigationController.viewControllers.last as? TodoCreatorViewController else { return }
        eventMakorViewController.updateSelectedDate(startDate: startDate, endDate: endDate)
    }
}

extension TodoCreatorCoordinator: SheetTimeDelegate {
    func didTapSaveButton(
        isAllDay: Bool,
        isAM: Bool,
        hour: Int,
        minute: Int
    ) {
        guard let eventMakorViewController = navigationController.viewControllers.last as? TodoCreatorViewController else { return }
        eventMakorViewController.updateSelectedTime(
            isAllDay: isAllDay,
            isAM: isAM,
            hour: hour,
            minute: minute
        )
    }
}
