import Combine
import TDDomain
import Foundation

final class WriteDiaryViewModel: BaseViewModel {
    enum Input {
    }
    
    enum Output {
        case failure(String)
    }
    
    // MARK: - Properties
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String
    private(set) var selectedDate: Date
    private(set) var selectedKeyword: [DiaryKeyword] = []
    
    // MARK: - Initializer
    
    init(
        selectedMood: String,
        selectedDate: Date,
        selectedKeyword: [DiaryKeyword]
    ) {
        self.selectedMood = selectedMood
        self.selectedDate = selectedDate
        self.selectedKeyword = selectedKeyword
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
                
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
