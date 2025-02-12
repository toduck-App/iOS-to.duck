import TDCore

public protocol ResetFocusCountUseCase {
    func execute() -> Result<Void, TDCore.TDDataError>
}

final class ResetFocusCountUseCaseImpl: ResetFocusCountUseCase {
    private let repository: TimerRepository

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute() -> Result<Void, TDCore.TDDataError> {
        return repository.resetFocusCount()
    }
}
