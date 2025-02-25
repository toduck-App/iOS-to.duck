import Combine
import Foundation

final class SignInViewModel: BaseViewModel {
    enum Input {
        case didTapSignIn
    }
    
    enum Output {
        case validSignIn
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .didTapSignIn:
                self?.output.send(.validSignIn)
            }
        }
        
        return output.eraseToAnyPublisher()
    }
}

