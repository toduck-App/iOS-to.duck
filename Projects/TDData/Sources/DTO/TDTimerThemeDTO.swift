import TDDomain

public struct TDTimerThemeDTO: Codable {
    private let timerTheme: Int

    init(timerTheme: Int) {
        self.timerTheme = timerTheme
    }
}

extension TDTimerThemeDTO {
    func convertToTDTimerTheme() -> TDTimerTheme {
        return TDTimerTheme.parse(value: timerTheme)
    }
}
