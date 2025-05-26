public protocol FocusRepository {
    // MARK: - Server
    
    func saveFocus(date: String, targetCount: Int, settingCount: Int, time: Int) async throws
    func fetchFocusPercent(yearMonth: String) async throws -> Int
    func fetchFocusList(yearMonth: String) async throws -> [Focus]
    
    
    // MARK: - User Defualt

    func fetchTimerSetting() -> TDTimerSetting
    func updateTimerSetting(setting: TDTimerSetting) throws
    func fetchTimerTheme() -> TDTimerTheme
    func updateTimerTheme(theme: TDTimerTheme) throws
    func fetchFocusCount() -> Int
    func updateFocusCount(count: Int) throws
    func resetFocusCount() throws
}
