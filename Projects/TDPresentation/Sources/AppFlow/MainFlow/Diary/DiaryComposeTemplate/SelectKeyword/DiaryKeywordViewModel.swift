import Combine
import Foundation

final class DiaryKeywordViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    // MARK: - Properties
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String
    private(set) var selectedDate: Date
    
    // MARK: - Initializer
    
    init(
        selectedMood: String,
        selectedDate: Date
    ) {
        self.selectedMood = selectedMood
        self.selectedDate = selectedDate
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

