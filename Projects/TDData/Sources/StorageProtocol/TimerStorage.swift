import Foundation
import TDCore

public protocol TimerStorage {
    func fetchTimerSetting() -> TDTimerSettingDTO?
    func updateTimerSetting(_ count: TDTimerSettingDTO) throws
    func fetchTheme() -> TDTimerThemeDTO?
    func updateTheme(_ theme: TDTimerThemeDTO) throws
    func fetchFocusCount() -> Int?
    func updateFocusCount(_ count: Int) throws
}
