import Foundation

public enum Weekday: String {
    case monday = "월"
    case tuesday = "화"
    case wednesday = "수"
    case thursday = "목"
    case friday = "금"
    case saturday = "토"
    case sunday = "일"
}


public struct Schedule: Hashable {
    public let id: UUID
    public let title: String
    public let imageURL: String?
    public let dateAndTime: Date?
    public let isRepeating: Bool
    public let repeatDays: [Weekday]?
    public let alarm: Bool
    public let alarmTimes: [AlarmTime]?
    public let place: String?
    public let memo: String?
    public let isFinish: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        imageURL: String? = nil,
        dateAndTime: Date? = nil,
        isRepeating: Bool,
        repeatDays: [Weekday]? = nil,
        alarm: Bool,
        alarmTimes: [AlarmTime]? = nil,
        place: String? = nil,
        memo: String? = nil,
        isFinish: Bool
    ) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.dateAndTime = dateAndTime
        self.isRepeating = isRepeating
        self.repeatDays = repeatDays
        self.alarm = alarm
        self.alarmTimes = alarmTimes
        self.place = place
        self.memo = memo
        self.isFinish = isFinish
    }
}
