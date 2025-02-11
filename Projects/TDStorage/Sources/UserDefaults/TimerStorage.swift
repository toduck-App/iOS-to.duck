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

    public func fetchTimerSetting() -> TDData.TDTimerSettingDTO? {
        guard let data = userDefaults.data(forKey: timerSettingKey),
            let decoded = try? JSONDecoder().decode(TDData.TDTimerSettingDTO.self, from: data)
        else { return nil }

        return decoded
    }

    public func updateTimerSetting(_ data: TDData.TDTimerSettingDTO) -> Result<Void, TDCore.TDDataError> {
        let encoder: JSONEncoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            userDefaults.set(data, forKey: timerSettingKey)
            return .success(())
        } catch {
            return .failure(.convertDTOFailure)
        }
    }

    public func fetchTheme() -> TDData.TDTimerThemeDTO? {
        guard let data = userDefaults.data(forKey: timerThemeKey),
            let decoded = try? JSONDecoder().decode(TDData.TDTimerThemeDTO.self, from: data)
        else { return nil }

        return decoded
    }

    public func updateTheme(_ data: TDData.TDTimerThemeDTO) -> Result<Void, TDCore.TDDataError> {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            userDefaults.set(data, forKey: timerThemeKey)
            return .success(())
        } catch {
            return .failure(.convertDTOFailure)
        }
    }

    public func fetchFocusCount() -> Int? {
        guard let data = userDefaults.object(forKey: focusCountKey) as? Int else { return nil }
        return data
    }

    public func updateFocusCount(_ data: Int) -> Result<Void, TDCore.TDDataError> {
        guard data >= 0 else { return .failure(.convertDTOFailure) }
        userDefaults.set(data, forKey: focusCountKey)
        return .success(())
    }
}
