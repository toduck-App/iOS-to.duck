import Combine
import TDDomain

final class DeleteEventViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    private let deleteScheduleUseCase: DeleteScheduleUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        deleteScheduleUseCase: DeleteScheduleUseCase
    ) {
        self.deleteScheduleUseCase = deleteScheduleUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

