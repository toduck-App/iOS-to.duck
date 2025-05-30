import TDCore

public protocol ResetFocusCountUseCase {
    func execute() throws
}

final class ResetFocusCountUseCaseImpl: ResetFocusCountUseCase {
    private let repository: FocusRepository

    public init(repository: FocusRepository) {
        self.repository = repository
    }

    public func execute() throws {
        return try repository.resetFocusCount()
    }
}
