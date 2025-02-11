import TDCore

public protocol TimerRepository {
    // MARK: - User Defualt

    func fetchTimerSetting() -> TDTimerSetting
    func updateTimerSetting(setting: TDTimerSetting) -> Result<Void, TDCore.TDDataError>

    func fetchTimerTheme() -> TDTimerTheme
    func updateTimerTheme(theme: TDTimerTheme) -> Result<Void, TDCore.TDDataError>

    // MARK: - Need Server

    func fetchFocusCount() -> Int
    func updateFocusCount(count: Int) -> Result<Void, TDCore.TDDataError>
    func resetFocusCount() -> Result<Void, TDCore.TDDataError>
}
