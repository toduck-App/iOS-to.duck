public enum AlarmTime: String {
    case tenMinutesBefore = "TEN_MINUTE"
    case thirtyMinutesBefore = "THIRTY_MINUTE"
    case oneHourBefore = "ONE_HOUR"
    
    public var title: String {
        switch self {
        case .tenMinutesBefore:
            return "10분 전"
        case .thirtyMinutesBefore:
            return "30분 전"
        case .oneHourBefore:
            return "1시간 전"
        }
    }
    
    public var time: Int {
        switch self {
        case .tenMinutesBefore:
            return 10
        case .thirtyMinutesBefore:
            return 30
        case .oneHourBefore:
            return 60
        }
    }
}
