import TDCore
import TDDomain

public struct RoutineRequestDTO: Encodable {
    let title: String
    let category: String
    let color: String
    let time: String?
    let isPublic: Bool
    let daysOfWeek: [String]
    let reminderMinutes: Int?
    let memo: String?
    
    init(from routine: Routine) {
        self.title = routine.title
        self.category = routine.category.imageName
        self.color = routine.category.colorHex
        self.time = routine.isAllDay ? nil : routine.time?.convertToString(formatType: .yearMonthDay)
        self.isPublic = routine.isPublic
        self.daysOfWeek = routine.repeatDays?.map { $0.rawValue } ?? []
        self.reminderMinutes = routine.alarmTime?.time
        self.memo = routine.memo
    }
}
