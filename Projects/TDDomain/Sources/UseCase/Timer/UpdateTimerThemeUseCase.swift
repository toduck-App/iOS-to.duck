import TDCore

public protocol UpdateTimerThemeUseCase {
    func execute(theme: TDTimerTheme) throws
}

final class UpdateTimerThemeUseCaseImpl: UpdateTimerThemeUseCase {
    private let repository: TimerRepository

    init(repository: TimerRepository) {
        self.repository = repository
    }

    func execute(theme: TDTimerTheme) throws {
        try repository.updateTimerTheme(theme: theme)
    }
}
