import Combine
import TDDomain
import Foundation

final class DiaryMakorViewModel: BaseViewModel {
    enum Input {
        case tapCategoryCell(String)
    }
    
    enum Output {
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String?
    private(set) var selectedDate: Date?
    private(set) var preDiary: Diary?
    
    init(
        selectedDate: Date? = nil,
        preDiary: Diary? = nil
    ) {
        self.selectedDate = selectedDate
        self.preDiary = preDiary
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .tapCategoryCell(let mood):
                self?.selectedMood = mood
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

