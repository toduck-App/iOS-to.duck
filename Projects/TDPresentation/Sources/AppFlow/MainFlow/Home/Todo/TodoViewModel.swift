import Combine
import Foundation
import TDDomain

final class TodoViewModel: BaseViewModel {
    enum Input {
        case fetchTodoList(startDate: String, endDate: String)
        case fetchRoutineDetail(any Eventable)
        case deleteTodayTodo(todoId: Int, isSchedule: Bool)
        case deleteAllTodo(todoId: Int, isSchedule: Bool)
        case checkBoxTapped(todo: any Eventable)
        case moveToTomorrow(todoId: Int, event: any Eventable)
    }
    
    enum Output {
        case fetchedTodoList
        case fetchedRoutineDetail(Routine)
        case successFinishTodo
        case tomorrowTodoCreated
        case deletedTodo
        case failure(error: String)
    }
    
    private let createScheduleUseCase: CreateScheduleUseCase
    private let createRoutineUseCase: CreateRoutineUseCase
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let fetchRoutineListUseCase: FetchRoutineListUseCase
    private let fetchRoutineUseCase: FetchRoutineUseCase
    private let finishScheduleUseCase: FinishScheduleUseCase
    private let finishRoutineUseCase: FinishRoutineUseCase
    private let deleteScheduleUseCase: DeleteScheduleUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var allDayTodoList: [any Eventable] = []
    private(set) var timedTodoList: [any Eventable] = []
    private var isOneDayDeleted: Bool = false
    var selectedDate: Date?
    
    init(
        createScheduleUseCase: CreateScheduleUseCase,
        createRoutineUseCase: CreateRoutineUseCase,
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        fetchRoutineListUseCase: FetchRoutineListUseCase,
        fetchRoutineUseCase: FetchRoutineUseCase,
        finishScheduleUseCase: FinishScheduleUseCase,
        finishRoutineUseCase: FinishRoutineUseCase,
        deleteScheduleUseCase: DeleteScheduleUseCase
    ) {
        self.createScheduleUseCase = createScheduleUseCase
        self.createRoutineUseCase = createRoutineUseCase
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.fetchRoutineListUseCase = fetchRoutineListUseCase
        self.fetchRoutineUseCase = fetchRoutineUseCase
        self.finishScheduleUseCase = finishScheduleUseCase
        self.finishRoutineUseCase = finishRoutineUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchTodoList(let startDate, let endDate):
                Task { await self?.fetchTodoList(startDate: startDate, endDate: endDate) }
            case .fetchRoutineDetail(let todo):
                Task { await self?.fetchRoutineDetail(with: todo) }
            case .deleteTodayTodo(let todoId, let isSchedule):
                self?.isOneDayDeleted = true
                self?.deleteEvent(todoId: todoId, isSchedule: isSchedule)
            case .deleteAllTodo(let todoId, let isSchedule):
                self?.isOneDayDeleted = false
                self?.deleteEvent(todoId: todoId, isSchedule: isSchedule)
            case .checkBoxTapped(let todo):
                Task { await self?.finishTodo(with: todo) }
            case .moveToTomorrow(let todoId, let event):
                let isSchedule = event.eventMode == .schedule
                let isAllDay = event.isAllDay
                self?.isOneDayDeleted = true
                self?.deleteEvent(todoId: todoId, isSchedule: isSchedule)
                self?.createEvent(todoId: todoId, isSchedule: isSchedule, isAllDay: isAllDay)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func createEvent(todoId: Int, isSchedule: Bool, isAllDay: Bool) {
        let event: any Eventable
        if isAllDay {
            event = allDayTodoList.first { $0.id == todoId }!
        } else {
            event = timedTodoList.first { $0.id == todoId }!
        }
        
        guard let selectedDate = selectedDate else {
            return
        }
        
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        let nextDayString = nextDay.convertToString(formatType: .yearMonthDay)
        
        if isSchedule {
            if let schedule = event as? Schedule {
                var updatedSchedule = schedule
                updatedSchedule.startDate = nextDayString
                updatedSchedule.endDate = nextDayString
                Task { await createSchedule(todoId: todoId, schedule: updatedSchedule) }
            }
        } else {
            if let routine = event as? Routine {
                Task { await createRoutine(with: todoId, routine: routine) }
            }
        }
    }
    
    private func createSchedule(todoId: Int, schedule: Schedule) async {
        do {
            try await createScheduleUseCase.execute(schedule: schedule)
            output.send(.tomorrowTodoCreated)
        } catch {
            output.send(.failure(error: "일정을 생성할 수 없습니다."))
        }
    }
    
    private func createRoutine(with todoId: Int, routine: Routine) async {
        do {
            try await createRoutineUseCase.execute(routine: routine)
            output.send(.tomorrowTodoCreated)
        } catch {
            output.send(.failure(error: "루틴을 생성할 수 없습니다."))
        }
    }
    
    private func fetchTodoList(startDate: String, endDate: String) async {
        do {
            let scheduleList = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            let routineList = try await fetchRoutineListUseCase.execute(dateString: startDate)
            
            let todoList: [any Eventable] = (scheduleList as [any Eventable]) + (routineList as [any Eventable])
            
            self.allDayTodoList = todoList.filter { $0.time == nil }
            self.timedTodoList = todoList
                .filter { $0.time != nil }
                .sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
            
            output.send(.fetchedTodoList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
    
    private func fetchRoutineDetail(with todo: any Eventable) async {
        guard let todo = todo as? Routine else { return }
        
        do {
            let routine = try await fetchRoutineUseCase.execute(routineId: todo.id ?? 0)
            output.send(.fetchedRoutineDetail(routine))
        } catch {
            output.send(.failure(error: "루틴을 불러오는데 실패했습니다."))
        }
    }
    
    private func finishTodo(with todo: any Eventable) async {
        if todo.eventMode == .schedule {
            await finishSchedule(with: todo)
        } else {
            await finishRoutine(with: todo)
        }
    }
    
    private func finishSchedule(with todo: any Eventable) async {
        do {
            try await finishScheduleUseCase.execute(
                scheduleId: todo.id ?? 0,
                isComplete: !todo.isFinished,
                queryDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? ""
            )
            output.send(.successFinishTodo)
        } catch {
            output.send(.failure(error: "일정을 완료할 수 없습니다."))
        }
    }
    
    private func finishRoutine(with todo: any Eventable) async {
        do {
            try await finishRoutineUseCase.execute(
                routineId: todo.id ?? 0,
                routineDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? "",
                isCompleted: !todo.isFinished
            )
            output.send(.successFinishTodo)
        } catch {
            output.send(.failure(error: "루틴을 완료할 수 없습니다."))
        }
    }
    
    private func deleteEvent(todoId: Int, isSchedule: Bool) {
        if isSchedule {
            Task { await deleteSchedule(scheduleId: todoId) }
        } else {
            Task { await deleteRoutine(routineId: todoId) }
        }
    }
    
    private func deleteSchedule(scheduleId: Int) async {
        do {
            try await deleteScheduleUseCase.execute(
                scheduleId: scheduleId,
                isOneDayDeleted: isOneDayDeleted,
                queryDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? ""
            )
            output.send(.deletedTodo)
        } catch {
            output.send(.failure(error: "일정을 삭제할 수 없습니다."))
        }
    }
    
    private func deleteRoutine(routineId: Int) async {
        do {
            
        } catch {
            output.send(.failure(error: "루틴을 삭제할 수 없습니다."))
        }
    }
}
