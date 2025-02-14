import TDCore

public protocol UpdateTimerThemeUseCase {
    func execute(theme: TDTimerTheme) -> Result<Void, TDCore.TDDataError>
}

final class UpdateTimerThemeUseCaseImpl: UpdateTimerThemeUseCase {
    private let repository: TimerRepository

    init(repository: TimerRepository) {
        self.repository = repository
    }

    func execute(theme: TDTimerTheme) -> Result<Void, TDCore.TDDataError> {
        return repository.updateTimerTheme(theme: theme)
    }
}