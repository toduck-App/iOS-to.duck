import Combine
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
    private(set) var todoList: [EventPresentable] = []
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchTodoList(let startDate, let endDate):
                break
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

