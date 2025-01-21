import Foundation

public struct Schedule: Eventable {
    public let id: Int? // 서버의 일정 PK
    public let title: String
    public let category: TDCategory
    public let startDate: Date
    public let endDate: Date // 단일 날짜 선택 시 startDate와 동일한 값 설정
    public let isAllDay: Bool
    public let time: Date?
    public let repeatDays: [TDWeekDay]?
    public let alarmTimes: [AlarmType]?
    public let place: String?
    public let memo: String?
    public let isFinish: Bool
    
    public init(
        id: Int?,
        title: String,
        category: TDCategory,
        startDate: Date,
        endDate: Date,
        isAllDay: Bool,
        time: Date?,
        repeatDays: [TDWeekDay]?,
        alarmTimes: [AlarmType]?,
        place: String?,
        memo: String?,
        isFinish: Bool
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
        self.isFinish = isFinish
    }
}
