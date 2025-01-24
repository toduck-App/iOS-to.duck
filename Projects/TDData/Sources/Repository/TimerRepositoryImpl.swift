//
//  TimerRepositoryImpl.swift
//  TDData
//
//  Created by 신효성 on 12/30/24.
//
import TDDomain

final class TimerRepositoryImpl: TimerRepository {
    
    //MARK: 임시
    private var theme: TDTimerTheme = .Bboduck
    private var setting: TDTimerSetting = .dummy()
    private var count: Int = 0
    
    func fetchTimerTheme() -> TDTimerTheme {
        return theme
    }
    
    func updateTimerTheme(theme: TDTimerTheme) {
        self.theme = theme
    }
    
    func fetchFocusCount() -> Int {
        return count
    }
    
    func updateFocusCount(count: Int) {
        self.count = count
    }
    
    func fetchTimerSetting() -> TDTimerSetting {
        return setting
    }
    
    func updateTimerSetting(setting: TDTimerSetting) {
        self.setting = setting
    }
}
