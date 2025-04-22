import Foundation

public struct Schedule: Eventable {
    public let id: Int? // 서버의 일정 PK
    public let title: String
    public let category: TDCategory
    public var startDate: String
    public var endDate: String // 단일 날짜 선택 시 startDate와 동일한 값 설정
    public let isAllDay: Bool
    public let time: String?
    public let repeatDays: [TDWeekDay]?
    public let alarmTime: AlarmTime?
    public let place: String?
    public let memo: String?
    public let isFinished: Bool
    public let scheduleRecords: [ScheduleRecord]?
    public let eventMode: TDEventMode = .schedule
    
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
        time: String?,
        repeatDays: [TDWeekDay]?,
        alarmTime: AlarmTime?,
        place: String?,
        memo: String?,
        isFinished: Bool,
        scheduleRecords: [ScheduleRecord]?
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTime = alarmTime
        self.place = place
        self.memo = memo
        self.isFinished = isFinished
        self.scheduleRecords = scheduleRecords
    }
}

public struct ScheduleRecord: Hashable {
    public let id: Int
    public let isComplete: Bool
    public let recordDate: String
    public let deletedAt: String?
    
    public init(id: Int, isComplete: Bool, recordDate: String, deletedAt: String?) {
        self.id = id
        self.isComplete = isComplete
        self.recordDate = recordDate
        self.deletedAt = deletedAt
    }
}
