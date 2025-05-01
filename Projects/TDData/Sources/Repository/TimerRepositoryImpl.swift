import TDCore
import TDDomain

final class TimerRepositoryImpl: TimerRepository {
    private let storage: TimerStorage
    
    init(storage: TimerStorage) {
        self.storage = storage
    }
    
    func fetchTimerSetting() -> TDTimerSetting {
        guard let dto = storage.fetchTimerSetting() else {
            return TDTimerSetting()
        }
        return dto.convertToTDTimerSetting()
    }
    
    func updateTimerSetting(setting: TDDomain.TDTimerSetting) throws {
        try storage.updateTimerSetting(
            TDTimerSettingDTO(
                maxFocusCount: setting.focusCountLimit,
                restDuration: setting.restDuration,
                focusDuration: setting.focusDuration
            ))
    }
    
    func fetchTimerTheme() -> TDDomain.TDTimerTheme {
        guard let dto = storage.fetchTheme() else {
            return .Bboduck
        }
        return dto.convertToTDTimerTheme()
    }
    
    func updateTimerTheme(theme: TDDomain.TDTimerTheme) throws {
        try storage.updateTheme(TDTimerThemeDTO(timerTheme: theme.rawValue))
    }
    
    func fetchFocusCount() -> Int {
        guard let count = storage.fetchFocusCount() else {
            TDLogger.debug("[TimerRepository#fetchFocusCount] Focus count is nil")
            return 0
        }
        return count
    }
    
    func updateFocusCount(count: Int) throws {
        try storage.updateFocusCount(count)
    }
    
    func resetFocusCount() throws {
        try storage.updateFocusCount(0)
    }
}
