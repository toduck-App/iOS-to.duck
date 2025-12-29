import Combine
import TDDomain
import Foundation

final class CompleteDiaryViewModel: BaseViewModel {
    enum Input {
        case fetchStreak
    }

    enum Output {
        case streak(Int)
        case failure(String)
    }

    // MARK: - Properties

    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let fetchDiaryStreakUseCase: FetchStreakUseCase
    let emotion: Emotion

    // MARK: - Initializer

    init(
        fetchDiaryStreakUseCase: FetchStreakUseCase,
        emotion: Emotion
    ) {
        self.fetchDiaryStreakUseCase = fetchDiaryStreakUseCase
        self.emotion = emotion
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .fetchStreak:
                Task { let response = try await self.fetchDiaryStreakUseCase.execute()
                    let streakCount = response.streak
                    self.output.send(.streak(streakCount))
                }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
