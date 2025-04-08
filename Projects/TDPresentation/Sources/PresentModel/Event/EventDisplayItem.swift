import UIKit
import TDDomain

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: EventPresentable {
    let id: Int?
    let title: String
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    let alarmTime: String?
    let date: String?
    let time: String?
    let repeatDays: String?
    let place: String?
    let isPublic: Bool
    let memo: String?
    let isFinished: Bool
    let isRepeating: Bool
    let eventMode: TDEventMode
    
    init(
        id: Int?,
        title: String,
        categoryIcon: UIImage?,
        categoryColor: UIColor,
        alarmTime: String?,
        date: String?,
        time: String?,
        repeatDays: String?,
        place: String?,
        isPublic: Bool = false,
        memo: String?,
        isFinished: Bool,
        isRepeating: Bool,
        eventMode: TDEventMode
    ) {
        self.id = id
        self.title = title
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.alarmTime = alarmTime
        self.date = date
        self.time = time
        self.repeatDays = repeatDays
        self.place = place
        self.isPublic = isPublic
        self.memo = memo
        self.isFinished = isFinished
        self.isRepeating = isRepeating
        self.eventMode = eventMode
    }
    
    init(
        from event: EventPresentable,
        alarmTime: String? = nil,
        date: String? = nil,
        repeatDays: String? = nil,
        place: String? = nil,
        isPublic: Bool = false
    ) {
        self.id = event.id
        self.title = event.title
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.alarmTime = alarmTime
        self.date = date
        self.time = event.time
        self.repeatDays = repeatDays
        self.place = place
        self.isPublic = isPublic
        self.memo = event.memo
        self.isFinished = event.isFinished
        self.isRepeating = event.isRepeating
        self.eventMode = event.eventMode
    }
    
    init(routine: Routine) {
        self.id = routine.id
        self.title = routine.title
        self.categoryIcon = UIImage(named: routine.category.imageName)
        self.categoryColor = routine.category.colorHex.convertToUIColor() ?? .white
        self.alarmTime = routine.alarmTime?.rawValue
        self.date = nil
        self.time = routine.time?.convertToString()
        self.repeatDays = routine.repeatDays?.map { $0.rawValue }.joined(separator: ", ")
        self.place = nil
        self.isPublic = routine.isPublic
        self.memo = routine.memo
        self.isFinished = routine.isFinished
        self.isRepeating = routine.isRepeating
        self.eventMode = routine.eventMode
    }
    
    init(schedule: Schedule) {
        self.id = schedule.id
        self.title = schedule.title
        self.categoryIcon = UIImage(named: schedule.category.imageName)
        self.categoryColor = schedule.category.colorHex.convertToUIColor() ?? .white
        self.alarmTime = schedule.alarmTime?.rawValue
        self.date = nil
        self.time = schedule.time?.convertToString()
        self.repeatDays = schedule.repeatDays?.map { $0.rawValue }.joined(separator: ", ")
        self.place = schedule.place
        self.isPublic = false
        self.memo = schedule.memo
        self.isFinished = schedule.isFinished
        self.isRepeating = false
        self.eventMode = schedule.eventMode
    }
}
