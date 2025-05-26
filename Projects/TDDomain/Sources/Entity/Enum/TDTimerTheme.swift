import TDCore

public enum TDTimerTheme: Int {
    case toduck
    case simple
}

public extension TDTimerTheme {
    static func parse(value: Int) -> TDTimerTheme {
        return TDTimerTheme(rawValue: value) ?? .simple
    }
}
