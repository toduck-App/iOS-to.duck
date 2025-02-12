import TDDomain

public struct TDTimerSettingDTO: Codable {
    private let maxFocusCount: Int
    private let restDuration: Int
    private let focusDuration: Int

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
