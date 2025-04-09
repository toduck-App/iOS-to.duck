import Combine
import Foundation
import TDDomain

final class TodoViewModel: BaseViewModel {
    enum Input {
        case fetchTodoList(startDate: String, endDate: String)
    }
    
    enum Output {
        case fetchedTodoList
        case failure(error: String)
    }
    
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var allDayTodoList: [any EventPresentable] = []
    private(set) var timedTodoList: [any EventPresentable] = []
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchTodoList(let startDate, let endDate):
                Task { await self?.fetchTodoList(startDate: startDate, endDate: endDate) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchTodoList(startDate: String, endDate: String) async {
        do {
            let todoList = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            self.allDayTodoList = todoList.filter { $0.time == nil }
            self.timedTodoList = todoList.filter { $0.time != nil }.sorted { timeSortKey($0.time) < timeSortKey($1.time) }
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
}
