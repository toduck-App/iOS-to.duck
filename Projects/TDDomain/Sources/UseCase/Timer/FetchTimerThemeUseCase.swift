import TDCore

public protocol FetchTimerThemeUseCase {
    func execute() -> TDTimerTheme
}

final class FetchTimerThemeUseCaseImpl: FetchTimerThemeUseCase {
    private let repository: FocusRepository

    init(repository: FocusRepository) {
        self.repository = repository
    }

    func execute() -> TDTimerTheme {
        return repository.fetchTimerTheme()
    }
}
