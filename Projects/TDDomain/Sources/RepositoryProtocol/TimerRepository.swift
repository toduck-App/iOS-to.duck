import TDCore

public protocol TimerRepository {
    // MARK: - User Defualt

    func fetchTimerSetting() -> TDTimerSetting
    func updateTimerSetting(setting: TDTimerSetting) throws

    func fetchTimerTheme() -> TDTimerTheme
    func updateTimerTheme(theme: TDTimerTheme) throws

    // MARK: - Need Server

    func fetchFocusCount() -> Int
    func updateFocusCount(count: Int) throws
    func resetFocusCount() throws
}
