import TDCore

public protocol ResetFocusCountUseCase {
    func execute() throws
}

final class ResetFocusCountUseCaseImpl: ResetFocusCountUseCase {
    private let repository: TimerRepository

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute() throws {
        return try repository.resetFocusCount()
    }
}
