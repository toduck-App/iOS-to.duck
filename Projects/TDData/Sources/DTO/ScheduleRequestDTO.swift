import Foundation
import TDDomain

public struct ScheduleRequestDTO: Encodable {
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
    
    public init(schedule: Schedule) {
        self.title = schedule.title
        self.category = schedule.category.imageName.uppercased()
        self.color = "#\(schedule.category.colorHex)"
        self.startDate = schedule.startDate
        self.endDate = schedule.endDate
        self.isAllDay = schedule.isAllDay
        self.time = schedule.time?.convertToString(formatType: .time24Hour)
        self.alarm = schedule.alarmTime?.rawValue
        self.daysOfWeek = schedule.repeatDays?.map { $0.rawValue }
        self.location = schedule.place
        self.memo = schedule.memo
    }
}
