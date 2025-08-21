import Combine
import Foundation
import TDDomain

final class TodoViewModel: BaseViewModel {
    enum Input {
        case didSelectedDate(date: Date)
        case fetchWeeklyTodoList(startDate: String, endDate: String)
        case deleteTodayTodo(todoId: Int, isSchedule: Bool)
        case deleteAllTodo(todoId: Int, isSchedule: Bool)
        case checkBoxTapped(todo: any TodoItem)
        case moveToTomorrow(todoId: Int, event: any TodoItem)
    }
    
    enum Output {
        case fetchedTodoList
        case fetchedRoutineDetail(Routine)
        case successFinishTodo
        case tomorrowTodoCreated
        case unionedTodoList
        case deletedTodo
        case failure(error: String)
    }
    
    private let createScheduleUseCase: CreateScheduleUseCase
    private let createRoutineUseCase: CreateRoutineUseCase
    private let fetchScheduleListUseCase: FetchServerScheduleListUseCase
    private let fetchRoutineListForDatesUseCase: FetchRoutineListForDatesUseCase
    private let fetchRoutineUseCase: FetchRoutineUseCase
    private let finishScheduleUseCase: FinishScheduleUseCase
    private let finishRoutineUseCase: FinishRoutineUseCase
    private let deleteScheduleUseCase: DeleteScheduleUseCase
    private let deleteRoutineAfterCurrentDayUseCase: DeleteRoutineAfterCurrentDayUseCase
    private let deleteRoutineForCurrentDayUseCase: DeleteRoutineForCurrentDayUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var weeklyScheduleList: [Date: [Schedule]] = [:]
    private var weeklyRoutineList: [Date: [Routine]] = [:]
    private var selectedDate = Date()
    private(set) var allDayTodoList: [any TodoItem] = []
    private(set) var timedTodoList: [any TodoItem] = []
    
    init(
        createScheduleUseCase: CreateScheduleUseCase,
        createRoutineUseCase: CreateRoutineUseCase,
        fetchScheduleListUseCase: FetchServerScheduleListUseCase,
        fetchRoutineListForDatesUseCase: FetchRoutineListForDatesUseCase,
        fetchRoutineUseCase: FetchRoutineUseCase,
        finishScheduleUseCase: FinishScheduleUseCase,
        finishRoutineUseCase: FinishRoutineUseCase,
        deleteScheduleUseCase: DeleteScheduleUseCase,
        deleteRoutineAfterCurrentDayUseCase: DeleteRoutineAfterCurrentDayUseCase,
        deleteRoutineForCurrentDayUseCase: DeleteRoutineForCurrentDayUseCase
    ) {
        self.createScheduleUseCase = createScheduleUseCase
        self.createRoutineUseCase = createRoutineUseCase
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.fetchRoutineListForDatesUseCase = fetchRoutineListForDatesUseCase
        self.fetchRoutineUseCase = fetchRoutineUseCase
        self.finishScheduleUseCase = finishScheduleUseCase
        self.finishRoutineUseCase = finishRoutineUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
        self.deleteRoutineAfterCurrentDayUseCase = deleteRoutineAfterCurrentDayUseCase
        self.deleteRoutineForCurrentDayUseCase = deleteRoutineForCurrentDayUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        let shared = input.share()
        
        shared
            .filter {
                switch $0 {
                case .checkBoxTapped:
                    return false
                default:
                    return true
                }
            }
            .sink { [weak self] event in
                switch event {
                case .fetchWeeklyTodoList(let startDate, let endDate):
                    Task { await self?.fetchWeeklyTodoList(startDate: startDate, endDate: endDate) }
                case .moveToTomorrow(let todoId, let event):
                    self?.handleMoveToTomorrow(todoId: todoId, event: event)
                case .deleteTodayTodo(let todoId, let isSchedule):
                    self?.deleteEvent(todoId: todoId, isSchedule: isSchedule, isOneDayDeleted: true)
                case .deleteAllTodo(let todoId, let isSchedule):
                    self?.deleteEvent(todoId: todoId, isSchedule: isSchedule, isOneDayDeleted: false)
                case .didSelectedDate(let selectedDate):
                    self?.selectedDate = selectedDate
                    self?.unionTodoListForSelectedDate(selectedDate: selectedDate)
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        shared
            .filter {
                switch $0 {
                case .checkBoxTapped:
                    return true
                default:
                    return false
                }
            }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] event in
                switch event {
                case .checkBoxTapped(let todo):
                    Task { await self?.finishTodo(with: todo) }
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - 투두 리스트 가져오기
    private func fetchWeeklyTodoList(startDate: String, endDate: String) async {
        do {
            let fetchedWeeklyScheduleList = try await fetchScheduleListUseCase.execute(
                startDate: startDate,
                endDate: endDate
            )
            let fetchedWeeklyRoutineList = try await fetchRoutineListForDatesUseCase.execute(
                startDate: startDate,
                endDate: endDate
            )
            self.weeklyScheduleList = fetchedWeeklyScheduleList
            self.weeklyRoutineList = fetchedWeeklyRoutineList
            output.send(.fetchedTodoList)
        } catch {
            output.send(.failure(error: "투두를 불러오는데 실패했습니다."))
        }
    }
    
    private func unionTodoListForSelectedDate(selectedDate: Date) {
        let selectedDateScheduleList = weeklyScheduleList[selectedDate.normalized] ?? []
        let selectedDateRoutineList = weeklyRoutineList[selectedDate.normalized] ?? []
        
        let todoList: [any TodoItem] = (selectedDateScheduleList as [any TodoItem]) + (selectedDateRoutineList as [any TodoItem])
        
        self.allDayTodoList = todoList.filter { $0.time == nil }
        self.timedTodoList = todoList
            .filter { $0.time != nil }
            .sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
        
        output.send(.unionedTodoList)
    }
    
    private func fetchRoutineDetail(with todo: any TodoItem) async {
        guard let todo = todo as? Routine else { return }
        
        do {
            let routine = try await fetchRoutineUseCase.execute(routineId: todo.id ?? 0)
            output.send(.fetchedRoutineDetail(routine))
        } catch {
            output.send(.failure(error: "루틴을 불러오는데 실패했습니다."))
        }
    }
    
    // MARK: - 투두 완료
    private func finishTodo(with todo: any TodoItem) async {
        if todo.eventMode == .schedule {
            await finishSchedule(with: todo)
        } else {
            await finishRoutine(with: todo)
        }
    }
    
    private func finishSchedule(with todo: any TodoItem) async {
        do {
            try await finishScheduleUseCase.execute(
                scheduleId: todo.id ?? 0,
                isComplete: !todo.isFinished,
                queryDate: selectedDate.convertToString(formatType: .yearMonthDay)
            )
            output.send(.successFinishTodo)
        } catch {
            output.send(.failure(error: "일정을 완료할 수 없습니다."))
        }
    }
    
    private func finishRoutine(with todo: any TodoItem) async {
        do {
            try await finishRoutineUseCase.execute(
                routineId: todo.id ?? 0,
                routineDate: selectedDate.convertToString(formatType: .yearMonthDay),
                isCompleted: !todo.isFinished
            )
            output.send(.successFinishTodo)
        } catch {
            output.send(.failure(error: "루틴을 완료할 수 없습니다."))
        }
    }
    
    // MARK: - 투두 삭제
    private func deleteEvent(todoId: Int, isSchedule: Bool, isOneDayDeleted: Bool) {
        if isSchedule {
            Task { await deleteSchedule(scheduleId: todoId, isOneDayDeleted: isOneDayDeleted) }
        } else {
            Task { await deleteRoutine(routineId: todoId, isOneDayDeleted: isOneDayDeleted) }
        }
    }
    
    private func deleteSchedule(scheduleId: Int, isOneDayDeleted: Bool) async {
        do {
            try await deleteScheduleUseCase.execute(
                scheduleId: scheduleId,
                isOneDayDeleted: isOneDayDeleted,
                queryDate: selectedDate.convertToString(formatType: .yearMonthDay)
            )
            removeEventFromWeeklyList(eventId: scheduleId, isSchedule: true)
            output.send(.deletedTodo)
        } catch {
            output.send(.failure(error: "일정을 삭제할 수 없습니다."))
        }
    }
    
    private func deleteRoutine(routineId: Int, isOneDayDeleted: Bool) async {
        do {
            if isOneDayDeleted {
                try await deleteRoutineForCurrentDayUseCase.execute(
                    routineId: routineId,
                    date: selectedDate.convertToString(formatType: .yearMonthDay)
                )
            } else {
                try await deleteRoutineAfterCurrentDayUseCase.execute(
                    routineId: routineId,
                    keepRecords: true
                )
            }
            output.send(.deletedTodo)
        } catch {
            output.send(.failure(error: "루틴을 삭제할 수 없습니다."))
        }
    }
    
    private func removeEventFromWeeklyList(eventId: Int, isSchedule: Bool) {
        if isSchedule {
            if let events = weeklyScheduleList[selectedDate] {
                weeklyScheduleList[selectedDate] = events.filter { $0.id != eventId }
            }
        } else {
            if let events = weeklyRoutineList[selectedDate] {
                weeklyRoutineList[selectedDate] = events.filter { $0.id != eventId }
            }
        }
        unionTodoListForSelectedDate(selectedDate: selectedDate)
    }
    
    // MARK: - 내일로 미루기
    private func handleMoveToTomorrow(todoId: Int, event: any TodoItem) {
        let isSchedule = event.eventMode == .schedule
        let isAllDay = event.isAllDay
        
        deleteEvent(todoId: todoId, isSchedule: isSchedule, isOneDayDeleted: true)
        updateEventToNextDay(todoId: todoId, isSchedule: isSchedule, isAllDay: isAllDay)
    }
    
    private func updateEventToNextDay(todoId: Int, isSchedule: Bool, isAllDay: Bool) {
        guard let event = getEvent(for: todoId, isAllDay: isAllDay) else { return }
        let nextDay = getNextDay(from: selectedDate)
        
        if isSchedule {
            if let schedule = event as? Schedule {
                var updatedSchedule = schedule
                updatedSchedule.startDate = nextDay
                updatedSchedule.endDate = nextDay
                Task { await createSchedule(todoId: todoId, schedule: updatedSchedule) }
            }
        } else {
            if let routine = event as? Routine {
                Task { await createRoutine(with: todoId, routine: routine) }
            }
        }
    }
    
    private func getEvent(for todoId: Int, isAllDay: Bool) -> (any TodoItem)? {
        if isAllDay {
            return allDayTodoList.first { $0.id == todoId }
        } else {
            return timedTodoList.first { $0.id == todoId }
        }
    }
    
    private func getNextDay(from date: Date) -> String {
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        return nextDay.convertToString(formatType: .yearMonthDay)
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
}
