import Foundation
import TDDomain

public struct ScheduleUpdateRequestDTO: Encodable {
    public let scheduleId: Int
    public let isOneDayDeleted: Bool
    public let queryDate: String
    public let scheduleData: ScheduleDataDTO

    public init(
        scheduleId: Int,
        isOneDayDeleted: Bool,
        queryDate: String,
        scheduleData: ScheduleDataDTO
    ) {
        self.scheduleId = scheduleId
        self.isOneDayDeleted = isOneDayDeleted
        self.queryDate = queryDate
        self.scheduleData = scheduleData
    }

    public init(
        schedule: Schedule,
        scheduleId: Int,
        isOneDayDeleted: Bool,
        queryDate: String
    ) {
        self.scheduleId = scheduleId
        self.isOneDayDeleted = isOneDayDeleted
        self.queryDate = queryDate
        self.scheduleData = ScheduleDataDTO(schedule: schedule)
    }
}

public struct ScheduleDataDTO: Encodable {
    public let title: String
    public let category: String
    public let color: String
    public let startDate: String
    public let endDate: String
    public let isAllDay: Bool
    public let time: String?
    public let alarm: String?
    public let daysOfWeek: [String]?
    public let location: String?
    public let memo: String?

    public init(
        title: String,
        category: String,
        color: String,
        startDate: String,
        endDate: String,
        isAllDay: Bool,
        time: String?,
        alarm: String?,
        daysOfWeek: [String]?,
        location: String?,
        memo: String?
    ) {
        self.title = title
        self.category = category
        self.color = color
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.time = time
        self.alarm = alarm
        self.daysOfWeek = daysOfWeek
        self.location = location
        self.memo = memo
    }

    public init(schedule: Schedule) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = schedule.time.map { formatter.string(from: $0) }

        self.title = schedule.title
        self.category = schedule.category.imageName
        self.color = schedule.category.colorHex
        self.startDate = schedule.startDate
        self.endDate = schedule.endDate
        self.isAllDay = schedule.isAllDay
        self.time = timeString
        self.alarm = schedule.alarmTime?.rawValue
        self.daysOfWeek = schedule.repeatDays?.map { $0.rawValue }
        self.location = schedule.place
        self.memo = schedule.memo
    }
}
