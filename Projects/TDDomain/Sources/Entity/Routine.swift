import Foundation

public struct Routine: Eventable, Identifiable {
    public let id: Int?
    public let title: String
    public let category: TDCategory
    public let isAllDay: Bool
    public let isPublic: Bool
    public let time: Date?
    public let repeatDays: [TDWeekDay]?
    public let alarmTime: AlarmType?
    public let memo: String?
    public let recommendedRoutines: [String]?
    public let isFinished: Bool
    public let shareCount: Int
    
    public var isRepeating: Bool {
        repeatDays != nil
    }
    
    public init(
        id: Int?,
        title: String,
        category: TDCategory,
        isAllDay: Bool,
        isPublic: Bool,
        time: Date?,
        repeatDays: [TDWeekDay]?,
        alarmTime: AlarmType?,
        memo: String?,
        recommendedRoutines: [String]?,
        isFinished: Bool,
        shareCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.isAllDay = isAllDay
        self.isPublic = isPublic
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTime = alarmTime
        self.memo = memo
        self.recommendedRoutines = recommendedRoutines
        self.isFinished = isFinished
        self.shareCount = shareCount
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
            id: 1,
            title: "하루 물 1L 이상 마시기",
            category: TDCategory(colorHex: "#FFD6E2 ", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            time: Date(),
            repeatDays: nil,
            alarmTime: nil,
            memo: "물만 마셔도 피부가 좋아진다나, 뭐라나,, ~~",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: 2,
            title: "자기 전 감정기록 작성하기",
            category: TDCategory(colorHex: "#FFE3CC", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            time: Date(),
            repeatDays: [.friday, .saturday],
            alarmTime: .oneHourBefore,
            memo: "감정 기록으로 오늘 하루를 되돌아보며 마무리",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: 3,
            title: "기상 후 이부자리 정리",
            category: TDCategory(colorHex: "#FFD6E2", imageName: "computer"),
            isAllDay: false,
            isPublic: false,
            time: Date().addingTimeInterval(60 * 60 * 2),
            repeatDays: [.saturday],
            alarmTime: nil,
            memo: "눈 뜨자마자 이부자리 정리하는 사람은 성공한다더라..",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: 4,
            title: "모닝 스트레칭 하기",
            category: TDCategory(colorHex: "#E4E9F3", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            time: Date(),
            repeatDays: nil,
            alarmTime: nil,
            memo: "찌뿌둥한 아침, 스트레칭으로 몸도 정신도 깨우기!",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: 5,
            title: "나가기 전 잊지 말고 챙기자",
            category: TDCategory(colorHex: "#FFE3CC", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            memo: "지갑, 차키, 에어팟, 접이식 우산",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: 6,
            title: "디자인 아티클 읽고 공부하기",
            category: TDCategory(colorHex: "#FFD6E2", imageName: "computer"),
            isAllDay: false,
            isPublic: true,
            time: Date().addingTimeInterval(60 * 60 * 7),
            repeatDays: nil,
            alarmTime: nil,
            memo: "시간 날 때 마다 틈틈히 읽어두기!",
            recommendedRoutines: nil,
            isFinished: false
        ),
        Routine(
            id: 7,
            title: "헬스장 가기! 빠샤!",
            category: TDCategory(colorHex: "#FFE3CC", imageName: "computer"),
            isAllDay: true,
            isPublic: true,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            memo: "더 이상 미룰 수 없다. 다이어트.",
            recommendedRoutines: nil,
            isFinished: false
        ),
    ]
}
