import TDCore

public enum TDTimerTheme: Int {
    case Bboduck
    case Simple
}

public extension TDTimerTheme {
    static func parse(value: Int) -> TDTimerTheme {
        return TDTimerTheme(rawValue: value) ?? .Simple
    }
}
