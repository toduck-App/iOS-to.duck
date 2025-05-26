import Foundation
import TDCore
import TDData

public final class TimerStorageImpl: TimerStorage {
    private let userDefaults: UserDefaults
    private let timerSettingKey = "timerSetting"
    private let timerThemeKey = "timerTheme"
    private let focusCountKey = "focusCount"
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func fetchTimerSetting() -> TDTimerSettingDTO? {
        guard let data = userDefaults.data(forKey: timerSettingKey),
            let decoded = try? JSONDecoder().decode(TDData.TDTimerSettingDTO.self, from: data)
        else { return nil }

        return decoded
    }

    public func updateTimerSetting(_ data: TDData.TDTimerSettingDTO) throws {
        let encoder: JSONEncoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            userDefaults.set(data, forKey: timerSettingKey)
        } catch {
            throw TDDataError.convertDTOFailure
        }
    }

    public func fetchTheme() -> TDTimerThemeDTO? {
        guard let data = userDefaults.data(forKey: timerThemeKey),
            let decoded = try? JSONDecoder().decode(TDData.TDTimerThemeDTO.self, from: data)
        else { return nil }

        return decoded
    }

    public func updateTheme(_ data: TDData.TDTimerThemeDTO) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            userDefaults.set(data, forKey: timerThemeKey)
        } catch {
            throw TDDataError.convertDTOFailure
        }
    }

    public func fetchFocusCount() -> Int? {
        guard let data = userDefaults.object(forKey: focusCountKey) as? Int else { return nil }
        return data
    }

    public func updateFocusCount(_ data: Int) throws {
        guard data >= 0 else { throw TDDataError.convertDTOFailure }
        userDefaults.set(data, forKey: focusCountKey)
    }
}
