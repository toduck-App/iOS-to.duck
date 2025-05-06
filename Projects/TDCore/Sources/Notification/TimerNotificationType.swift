import UserNotifications

public enum TimerNotificationType {
    case pause
    case restEndingSoon
    case restFinished

    public var title: String {
        switch self {
        case .pause:
            return "집중 타이머를 잠시 멈췄어요"
        case .restEndingSoon:
            return "휴식이 곧 끝나요 ⏰"
        case .restFinished:
            return "휴식 시간 끝 💡️"
        }
    }

    public var body: String {
        switch self {
        case .pause:
            return "20초 안에 재시작하면 집중시간이 이어집니다"
        case .restEndingSoon:
            return "1분 후엔 집중 시간이에요. 자리로 돌아갈 준비를 해볼까요?"
        case .restFinished:
            return "집중할 시간이에요 ! 자리에 앉아볼까요?"
        }
    }
}
