//
//  TimerRepositoryImpl.swift
//  TDData
//
//  Created by 신효성 on 12/30/24.
//
import TDCore
import TDDomain

final class TimerRepositoryImpl: TimerRepository {
    private let storage: TimerStorage

    init(storage: TimerStorage) {
        self.storage = storage
    }

    func fetchTimerSetting() -> TDDomain.TDTimerSetting {
        guard let dto = storage.fetchTimerSetting() else {
            return TDTimerSetting()
        }
        return dto.convertToTDTimerSetting()
    }

    func updateTimerSetting(setting: TDDomain.TDTimerSetting) -> Result<Void, TDCore.TDDataError> {
        return storage.updateTimerSetting(
            TDTimerSettingDTO(
                maxFocusCount: setting.maxFocusCount,
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

    func updateTimerTheme(theme: TDDomain.TDTimerTheme) -> Result<Void, TDCore.TDDataError> {
         return storage.updateTheme(TDTimerThemeDTO(timerTheme: theme.rawValue))
    }

    func fetchFocusCount() -> Int {
        guard let count = storage.fetchFocusCount() else {
            TDLogger.debug("[TimerRepository#fetchFocusCount] Focus count is nil")
            return 0
        }
        return count
    }

    func updateFocusCount(count: Int) -> Result<Void, TDCore.TDDataError> {
        return storage.updateFocusCount(count)
    }

    func resetFocusCount() -> Result<Void, TDCore.TDDataError> {
        return storage.updateFocusCount(0)
    }
}
