import TDCore

public protocol UpdateFocusCountUseCase {
    func execute(_ count: Int) throws
}

final class UpdateFocusCountUseCaseImpl: UpdateFocusCountUseCase {
    private let repository: FocusRepository
    private let min = 0

    public init(repository: FocusRepository) {
        self.repository = repository
    }

    public func execute(_ count: Int) throws {
        guard count >= min else {
            throw TDDataError.updateEntityFailure
        }

        try repository.updateFocusCount(count: count)
    }
}
