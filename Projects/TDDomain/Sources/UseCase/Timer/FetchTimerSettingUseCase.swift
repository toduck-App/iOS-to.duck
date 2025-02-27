public protocol FetchTimerSettingUseCase {
    func execute() -> TDTimerSetting
}

final class FetchTimerSettingUseCaseImpl: FetchTimerSettingUseCase {
    private let repository: TimerRepository

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute() -> TDTimerSetting {
        return repository.fetchTimerSetting()
    }
}
