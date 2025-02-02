//
//  UpdateTimerSettingUseCase.swift
//  TDDomain
//
//  Created by 신효성 on 12/30/24.
//

public protocol UpdateTimerSettingUseCase {
    func execute(setting: TDTimerSetting)
}

final class UpdateTimerSettingUseCaseImpl: UpdateTimerSettingUseCase {
    private let repository: TimerRepository

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute(setting: TDTimerSetting) {
        repository.updateTimerSetting(setting: setting)
    }
}
