import Combine
import Foundation

final class DiaryMakorViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        case notificationScrollToBottom
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}

