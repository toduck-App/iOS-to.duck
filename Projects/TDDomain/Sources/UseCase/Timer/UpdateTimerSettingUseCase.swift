import TDCore
public protocol UpdateTimerSettingUseCase {
    func execute(setting: TDTimerSetting) -> Result<Void, TDCore.TDDataError>
}

final class UpdateTimerSettingUseCaseImpl: UpdateTimerSettingUseCase {
    private let repository: TimerRepository
    private let max = 5
    private let min = 1
    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute(setting: TDTimerSetting) -> Result<Void, TDCore.TDDataError> {
        guard setting.maxFocusCount >= min, setting.maxFocusCount <= max else {
            return .failure(.updateEntityFailure)
         }
        return repository.updateTimerSetting(setting: setting)
    }
}
