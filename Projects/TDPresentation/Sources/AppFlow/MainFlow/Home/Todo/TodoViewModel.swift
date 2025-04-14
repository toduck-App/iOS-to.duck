import Combine
import Foundation
import TDDomain

final class TodoViewModel: BaseViewModel {
    enum Input {
        case fetchTodoList(startDate: String, endDate: String)
        case fetchRoutineDetail(any EventPresentable)
        case checkBoxTapped(todo: any EventPresentable)
    }
    
    enum Output {
        case fetchedTodoList
        case fetchedRoutineDetail(Routine)
        case successFinishSchedule
        case failure(error: String)
    }
    
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let fetchRoutineListUseCase: FetchRoutineListUseCase
    private let fetchRoutineUseCase: FetchRoutineUseCase
    private let finishScheduleUseCase: FinishScheduleUseCase
    private let finishRoutineUseCase: FinishRoutineUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var allDayTodoList: [any EventPresentable] = []
    private(set) var timedTodoList: [any EventPresentable] = []
    var selectedDate: Date?
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        fetchRoutineListUseCase: FetchRoutineListUseCase,
        fetchRoutineUseCase: FetchRoutineUseCase,
        finishScheduleUseCase: FinishScheduleUseCase,
        finishRoutineUseCase: FinishRoutineUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.fetchRoutineListUseCase = fetchRoutineListUseCase
        self.fetchRoutineUseCase = fetchRoutineUseCase
        self.finishScheduleUseCase = finishScheduleUseCase
        self.finishRoutineUseCase = finishRoutineUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchTodoList(let startDate, let endDate):
                Task { await self?.fetchTodoList(startDate: startDate, endDate: endDate) }
            case .fetchRoutineDetail(let todo):
                Task { await self?.fetchRoutineDetail(with: todo) }
            case .checkBoxTapped(let todo):
                Task { await self?.finishSchedule(with: todo) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchTodoList(startDate: String, endDate: String) async {
        do {
            let scheduleList = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            let routineList = try await fetchRoutineListUseCase.execute(dateString: startDate)
            
            let todoList: [any EventPresentable] = (scheduleList as [any EventPresentable]) + (routineList as [any EventPresentable])
            
            self.allDayTodoList = todoList.filter { $0.time == nil }
            self.timedTodoList = todoList
                .filter { $0.time != nil }
                .sorted { timeSortKey($0.time) < timeSortKey($1.time) }
            
            output.send(.fetchedTodoList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
    
    func timeSortKey(_ time: String?) -> Int {
        guard let time, time != "종일" else { return 0 }
        
        if let date = Date.convertFromString(time, format: .time24Hour) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            return hour * 60 + minute
        }
        
        return Int.max
    }
    
    private func fetchRoutineDetail(with todo: any EventPresentable) async {
        guard let todo = todo as? Routine else { return }
        
        do {
            let routine = try await fetchRoutineUseCase.execute(routineId: todo.id ?? 0)
            output.send(.fetchedRoutineDetail(routine))
        } catch {
            output.send(.failure(error: "루틴을 불러오는데 실패했습니다."))
        }
    }
    
    private func finishTodo(with todo: any EventPresentable) async {
        if todo.eventMode == .schedule {
            await finishSchedule(with: todo)
        } else {
            await finishRoutine(with: todo)
        }
    }
    
    private func finishSchedule(with todo: any EventPresentable) async {
        do {
            try await finishScheduleUseCase.execute(
                scheduleId: todo.id ?? 0,
                isComplete: !todo.isFinished,
                queryDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? ""
            )
            output.send(.successFinishSchedule)
        } catch {
            output.send(.failure(error: "일정을 완료할 수 없습니다."))
        }
    }
    
    private func finishRoutine(with todo: any EventPresentable) async {
        do {
            try await finishRoutineUseCase.execute(
                routineId: todo.id ?? 0,
                routineDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? "",
                isCompleted: !todo.isFinished
            )
            output.send(.successFinishSchedule)
        } catch {
            output.send(.failure(error: "루틴을 완료할 수 없습니다."))
        }
    }
}
