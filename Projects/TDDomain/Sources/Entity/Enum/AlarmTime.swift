public enum AlarmTime: String {
    case tenMinutesBefore = "TEN_MINUTE"
    case thirtyMinutesBefore = "THIRTY_MINUTE"
    case oneHourBefore = "ONE_HOUR"
    case oneDayBefore = "ONE_DAY"
    
    public var title: String {
        switch self {
        case .tenMinutesBefore:
            return "10분 전"
        case .thirtyMinutesBefore:
            return "30분 전"
        case .oneHourBefore:
            return "1시간 전"
        case .oneDayBefore:
            return "하루 전"
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
        case .oneDayBefore:
            return 1440
        }
    }
}
