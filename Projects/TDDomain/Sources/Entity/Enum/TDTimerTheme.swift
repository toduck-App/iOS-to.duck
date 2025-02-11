import TDCore

public enum TDTimerTheme: Int {
    case Bboduck
    case Simple
}

extension TDTimerTheme {
    public static func parse(value: Int) -> TDTimerTheme {
        switch value {
        case 0:
            return .Bboduck
        case 1:
            return .Simple
        default:
            return .Simple
        }
    }
}