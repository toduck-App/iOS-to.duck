import Combine
import Foundation

final class DiaryMakorViewModel: BaseViewModel {
    enum Input {
        case tapCategoryCell(String)
        case scrollToBottom
    }
    
    enum Output {
        case notificationScrollToBottom
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .scrollToBottom:
                self?.output.send(.notificationScrollToBottom)
            case .tapCategoryCell(let mood):
                self?.selectedMood = mood
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

