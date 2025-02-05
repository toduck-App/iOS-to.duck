//
//  TimerRepository.swift
//  TDDomain
//
//  Created by 신효성 on 12/30/24.
//

public protocol TimerRepository {
    // MARK: - User Defualt

    func fetchTimerSetting() -> TDTimerSetting
    func updateTimerSetting(setting: TDTimerSetting)

    func fetchTimerTheme() -> TDTimerTheme
    func updateTimerTheme(theme: TDTimerTheme)

    // MARK: - Need Server

    func fetchFocusCount() -> Int
    func updateFocusCount(count: Int)
}
