import TDCore

public protocol UpdateTimerSettingUseCase {
    func execute(setting: TDTimerSetting) throws
}

final class UpdateTimerSettingUseCaseImpl: UpdateTimerSettingUseCase {
    private let repository: FocusRepository
    private let max = 5
    private let min = 1
    public init(repository: FocusRepository) {
        self.repository = repository
    }

    public func execute(setting: TDTimerSetting) throws {
        guard setting.focusCountLimit >= min, setting.focusCountLimit <= max else {
            throw TDDataError.updateEntityFailure
         }
        return try repository.updateTimerSetting(setting: setting)
    }
}
