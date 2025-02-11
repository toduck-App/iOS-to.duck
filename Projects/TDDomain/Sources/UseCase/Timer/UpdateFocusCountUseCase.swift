import TDCore

public protocol UpdateFocusCountUseCase {
    func execute(_ count: Int) -> Result<Void, TDCore.TDDataError>
}

final class UpdateFocusCountUseCaseImpl: UpdateFocusCountUseCase {
    private let repository: TimerRepository
    private let min = 1

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute(_ count: Int) -> Result<Void, TDCore.TDDataError> {
        let max = repository.fetchTimerSetting().maxFocusCount

        guard count >= min, count <= max else { 
            return .failure(.updateEntityFailure)
         }

        return repository.updateFocusCount(count: count)
    }
}
