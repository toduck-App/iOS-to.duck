import Foundation

public struct Schedule: Eventable {
    public let id: Int? // 서버의 일정 PK
    public let title: String
    public let category: TDCategory
    public let startDate: String
    public let endDate: String // 단일 날짜 선택 시 startDate와 동일한 값 설정
    public let isAllDay: Bool
    public let time: Date?
    public let repeatDays: [TDWeekDay]?
    public let alarmTimes: [AlarmType]?
    public let place: String?
    public let memo: String?
    public let isFinished: Bool
    
    public var isRepeating: Bool {
        repeatDays != nil || startDate != endDate
    }
    
    public init(
        id: Int?,
        title: String,
        category: TDCategory,
        startDate: String,
        endDate: String,
        isAllDay: Bool,
        time: Date?,
        repeatDays: [TDWeekDay]?,
        alarmTimes: [AlarmType]?,
        place: String?,
        memo: String?,
        isFinished: Bool
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTimes = alarmTimes
        self.place = place
        self.memo = memo
        self.isFinished = isFinished
    }
}

extension Schedule {
    public static let dummy: [Schedule] = [
        Schedule(
            id: 0,
            title: "1번 일정",
            category: TDCategory(colorHex: "#123456", imageName: "power"),
            startDate: "2021-09-01",
            endDate: "2021-09-01",
            isAllDay: false,
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            place: "장소1",
            memo: "메모1",
            isFinished: false
        ), Schedule(
            id: 0,
            title: "2번 일정",
            category: TDCategory(colorHex: "#FFE3CC", imageName: "sleep"),
            startDate: "2021-09-01",
            endDate: "2022-10-10",
            isAllDay: false,
            time: Date(),
            repeatDays: nil,
            alarmTimes: nil,
            place: "장소2",
            memo: "메모2",
            isFinished: false
        )
    ]
}
