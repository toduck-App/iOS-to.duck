import Combine
import TDCore
import TDDomain

final class SheetTimeViewModel: BaseViewModel {
    enum Input {
        case saveButtonTapped
    }
    
    enum Output {
        case saved
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .saveButtonTapped:
                self?.output.send(.saved)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
