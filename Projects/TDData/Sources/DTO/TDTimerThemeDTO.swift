import TDDomain
public struct TDTimerThemeDTO: Codable {
    public let timerTheme: Int

    public init(timerTheme: Int) {
        self.timerTheme = timerTheme
    }
}

extension TDTimerThemeDTO {
    func convertToTDTimerTheme() -> TDTimerTheme {
        return TDTimerTheme.parse(value: timerTheme)
    }
}
