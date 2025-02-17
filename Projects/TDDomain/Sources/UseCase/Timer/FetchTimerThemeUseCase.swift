import TDCore

public protocol FetchTimerThemeUseCase {
    func execute() -> TDTimerTheme
}

final class FetchTimerThemeUseCaseImpl: FetchTimerThemeUseCase {
    private let repository: TimerRepository

    init(repository: TimerRepository) {
        self.repository = repository
    }

    func execute() -> TDTimerTheme {
        return repository.fetchTimerTheme()
    }
}