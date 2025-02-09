import Foundation

struct RecommendedRoutine: Hashable {
    let title: String
    let time: Date? // AM 07:30
    let memo: String?
}

public struct Routine: Eventable, Identifiable {
    public let id: Int?
    public let title: String
    public let category: TDCategory
    public let isAllDay: Bool
    public let isPublic: Bool
    public let date: Date?
    public let time: Date?
    public let repeatDays: [TDWeekDay]?
    public let alarmTimes: [AlarmType]?
    public let memo: String?
    public let recommendedRoutines: [String]?
    public let isFinished: Bool
    
    public init(
        id: Int?,
        title: String,
        category: TDCategory,
        isAllDay: Bool,
        isPublic: Bool,
        date: Date?,
        time: Date?,
        repeatDays: [TDWeekDay]?,
        alarmTimes: [AlarmType]?,
        memo: String?,
        recommendedRoutines: [String]?,
        isFinished: Bool
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.isAllDay = isAllDay
        self.isPublic = isPublic
        self.date = date
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTimes = alarmTimes
        self.memo = memo
        self.recommendedRoutines = recommendedRoutines
        self.isFinished = isFinished
    }
}

extension Routine: Hashable {
    public static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Routine {
    public static let dummy: [Routine] = [
        Routine(
            id: nil,
            title: "하루 물 1L 이상 마시기",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "물만 마셔도 피부가 좋아진다나, 뭐라나,, ~~",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: nil,
            title: "자기 전 감정기록 작성하기",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "감정 기록으로 오늘 하루를 되돌아보며 마무리",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: nil,
            title: "기상 후 이부자리 정리",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "눈 뜨자마자 이부자리 정리하는 사람은 성공한다더라..",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: nil,
            title: "모닝 스트레칭 하기",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "찌뿌둥한 아침, 스트레칭으로 몸도 정신도 깨우기!",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: nil,
            title: "나가기 전 잊지 말고 챙기자",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "지갑, 차키, 에어팟, 접이식 우산",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: nil,
            title: "디자인 아티클 읽고 공부하기",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "시간 날 때 마다 틈틈히 읽어두기!",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: nil,
            title: "헬스장 가기! 빠샤!",
            category: TDCategory(colorHex: "#123456", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            date: Date(),
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            memo: "더 이상 미룰 수 없다. 다이어트.",
            recommendedRoutines: nil,
            isFinished: false
        ),
    ]
}
