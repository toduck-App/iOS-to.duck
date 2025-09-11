import Combine
import TDDomain

final class DiaryComposeTemplateViewModel: BaseViewModel {
    enum Input {
        case selectEmotion(Int?)
    }
    
    enum Output {
        case selectedEmotion(String?)
    }
    
    // MARK: - Properties
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedEmotionIndex: Int?
    let emotions = Emotion.allCases
    
    init(
        
    ) {
        
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectEmotion(let index):
                self?.selectEmotion(at: index)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func selectEmotion(at index: Int?) {
        selectedEmotionIndex = index
        let emotion = index != nil ? emotions[index ?? 0] : nil
        output.send(.selectedEmotion(emotion?.phrases.randomElement()))
    }
}

