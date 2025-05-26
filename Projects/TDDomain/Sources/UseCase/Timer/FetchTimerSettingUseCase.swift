public protocol FetchTimerSettingUseCase {
    func execute() -> TDTimerSetting
}

final class FetchTimerSettingUseCaseImpl: FetchTimerSettingUseCase {
    private let repository: FocusRepository

    public init(repository: FocusRepository) {
        self.repository = repository
    }

    public func execute() -> TDTimerSetting {
        return repository.fetchTimerSetting()
    }
}
