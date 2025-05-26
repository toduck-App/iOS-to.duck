import TDCore
import TDDomain

public struct RoutineRequestDTO: Encodable {
    public let title: String
    public let category: String
    public let color: String
    public let time: String?
    public let isPublic: Bool
    public let daysOfWeek: [String]?
    public let reminderMinutes: Int?
    public let memo: String?
    
    public init(from routine: Routine) {
        self.title = routine.title
        self.category = routine.category.imageName.uppercased()
        self.color = routine.category.colorHex
        self.time = routine.isAllDay ? nil : routine.time
        self.isPublic = routine.isPublic
        self.daysOfWeek = routine.repeatDays?.map { $0.rawValue } ?? []
        self.reminderMinutes = routine.alarmTime?.time
        self.memo = routine.memo
    }
}
