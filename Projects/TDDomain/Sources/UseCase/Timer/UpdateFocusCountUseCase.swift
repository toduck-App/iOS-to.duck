import TDCore

public protocol UpdateFocusCountUseCase {
    func execute(_ count: Int) -> Result<Void, TDCore.TDDataError>
}

final class UpdateFocusCountUseCaseImpl: UpdateFocusCountUseCase {
    private let repository: TimerRepository
    private let min = 0

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute(_ count: Int) -> Result<Void, TDCore.TDDataError> {
        guard count >= min else { 
            return .failure(.updateEntityFailure)
        }

        return repository.updateFocusCount(count: count)
    }
}
