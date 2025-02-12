import Foundation
import TDCore

public protocol TimerStorage {
    func fetchTimerSetting() -> TDTimerSettingDTO?
    func updateTimerSetting(_ count: TDTimerSettingDTO) -> Result<Void, TDCore.TDDataError>
    func fetchTheme() -> TDTimerThemeDTO?
    func updateTheme(_ theme: TDTimerThemeDTO) -> Result<Void, TDCore.TDDataError>
    func fetchFocusCount() -> Int?
    func updateFocusCount(_ count: Int) -> Result<Void, TDCore.TDDataError>
}
