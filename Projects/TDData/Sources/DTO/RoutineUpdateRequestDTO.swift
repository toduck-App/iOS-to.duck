import TDCore
import TDDomain

public struct RoutineUpdateRequestDTO: Encodable {
    public let title: String
    public let category: String
    public let color: String
    public let time: String?
    public let isPublic: Bool
    public let daysOfWeek: [String]?
    public let reminderMinutes: Int?
    public let memo: String?
    public let isTitleChanged: Bool
    public let isCategoryChanged: Bool
    public let isColorChanged: Bool
    public let isTimeChanged: Bool
    public let isPublicChanged: Bool
    public let isDaysOfWeekChanged: Bool
    public let isReminderMinutesChanged: Bool
    public let isMemoChanged: Bool
    
    public init(from preRoutine: Routine, to routine: Routine) {
        self.title = routine.title
        self.category = routine.category.imageName.uppercased()
        self.color = routine.category.colorHex
        self.time = routine.isAllDay ? nil : routine.time
        self.isPublic = routine.isPublic
        self.daysOfWeek = routine.repeatDays?.map { $0.rawValue } ?? []
        self.reminderMinutes = routine.alarmTime?.time
        self.memo = routine.memo
        self.isTitleChanged = preRoutine.title != routine.title
        self.isCategoryChanged = preRoutine.category.imageName.uppercased() != routine.category.imageName.uppercased()
        self.isColorChanged = preRoutine.category.colorHex != routine.category.colorHex
        self.isTimeChanged = preRoutine.isAllDay != routine.isAllDay
        self.isPublicChanged = preRoutine.isPublic != routine.isPublic
        self.isDaysOfWeekChanged = preRoutine.repeatDays != routine.repeatDays
        self.isReminderMinutesChanged = preRoutine.alarmTime?.time != routine.alarmTime?.time
        self.isMemoChanged = preRoutine.memo != routine.memo
    }
}
