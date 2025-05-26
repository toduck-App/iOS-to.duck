import TDCore

public protocol UpdateTimerThemeUseCase {
    func execute(theme: TDTimerTheme) throws
}

final class UpdateTimerThemeUseCaseImpl: UpdateTimerThemeUseCase {
    private let repository: FocusRepository

    init(repository: FocusRepository) {
        self.repository = repository
    }

    func execute(theme: TDTimerTheme) throws {
        try repository.updateTimerTheme(theme: theme)
    }
}
