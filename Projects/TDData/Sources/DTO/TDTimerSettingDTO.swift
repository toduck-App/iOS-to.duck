import TDDomain

public struct TDTimerSettingDTO: Codable {
    public let maxFocusCount: Int
    public let restDuration: Int
    public let focusDuration: Int

    public init(maxFocusCount: Int, restDuration: Int, focusDuration: Int) {
        self.maxFocusCount = maxFocusCount
        self.restDuration = restDuration
        self.focusDuration = focusDuration
    }
}

extension TDTimerSettingDTO {
    func convertToTDTimerSetting() -> TDTimerSetting {
        return TDTimerSetting(
            focusDuration: focusDuration,
            maxFocusCount: maxFocusCount,
            restDuration: restDuration
        )
    }
}
