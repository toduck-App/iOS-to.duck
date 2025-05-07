import UserNotifications

public enum LocalNotificationType {
    case timerPause
    case timerRestFinished

    public var title: String {
        switch self {
        case .timerPause:
            return "집중 타이머를 잠시 멈췄어요"
        case .timerRestFinished:
            return "휴식 시간 끝 💡️"
        }
    }

    public var body: String {
        switch self {
        case .timerPause:
            return "20초 안에 재시작하면 집중시간이 이어집니다"
        case .timerRestFinished:
            return "곧 집중할 시간이에요! 자리에 앉아볼까요?"
        }
    }
}
