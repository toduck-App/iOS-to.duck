import TDDomain

public struct TDTimerSettingDTO: Codable {
    public let focusCount: Int
    public let restDuration: Int
    public let focusDuration: Int

    public init(focusCount: Int, restDuration: Int, focusDuration: Int) {
        self.focusCount = focusCount
        self.restDuration = restDuration
        self.focusDuration = focusDuration
    }
}

extension TDTimerSettingDTO {
    func convertToTDTimerSetting() -> TDTimerSetting {
        return TDTimerSetting(
            focusDuration: focusDuration,
            foucsCount: focusCount,
            restDuration: restDuration
        )
    }
}
