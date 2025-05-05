import TDDomain

struct FocusRepositoryImpl: FocusRepository {
    private let service: FocusService
    private let storage: TimerStorage
    
    init(service: FocusService, storage: TimerStorage) {
        self.service = service
        self.storage = storage
    }
    
    func saveFocus(date: String, targetCount: Int, settingCount: Int, time: Int) async throws {
        try await service.saveFocus(date: date, targetCount: targetCount, settingCount: settingCount, time: time)
    }
    
    func fetchFocusPercent(yearMonth: String) async throws -> Int {
        let response = try await service.fetchFocusPercent(yearMonth: yearMonth)
        return response.percent
    }
    
    func fetchFocusList(yearMonth: String) async throws -> [Focus] {
        let response = try await service.fetchFocusList(yearMonth: yearMonth)
        let focusList = response.convertToFocusList()
        
        return focusList
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
            return .toduck
        }
        return dto.convertToTDTimerTheme()
    }
    
    func updateTimerTheme(theme: TDDomain.TDTimerTheme) throws {
        try storage.updateTheme(TDTimerThemeDTO(timerTheme: theme.rawValue))
    }
    
    func fetchFocusCount() -> Int {
        guard let count = storage.fetchFocusCount() else {
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
