import Foundation

public struct Schedule {
    public let id: UUID
    public let title: String
    public let category: TDCategory
    public let isAllDay: Bool
    public let date: Date?
    public let time: Date?
    public let repeatDays: [TDWeekDay]?
    public let alarmTimes: [AlarmType]?
    public let place: String?
    public let memo: String?
    public let isFinish: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        category: TDCategory,
        isAllDay: Bool,
        date: Date?,
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
        self.isAllDay = isAllDay
        self.date = date
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTimes = alarmTimes
        self.place = place
        self.memo = memo
        self.isFinish = isFinish
    }
}
