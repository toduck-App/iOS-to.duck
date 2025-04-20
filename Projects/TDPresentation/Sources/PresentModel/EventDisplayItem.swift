import UIKit
import TDDomain

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: EventPresentable {
    let id: Int?
    let title: String
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    let date: String?
    let time: String?
    let repeatDays: [TDWeekDay]?
    let alarmTime: AlarmTime?
    let place: String?
    let isPublic: Bool
    let memo: String?
    let isFinished: Bool
    let isRepeating: Bool
    let eventMode: TDEventMode
    
    init(
        from event: any EventPresentable,
        place: String? = nil,
        date: String? = nil,
        isPublic: Bool = false
    ) {
        self.id = event.id
        self.title = event.title
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.alarmTime = event.alarmTime
        self.date = date
        self.time = event.time
        self.repeatDays = event.repeatDays
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
        self.categoryIcon = routine.categoryIcon
        self.categoryColor = routine.category.colorHex.convertToUIColor() ?? .white
        self.alarmTime = routine.alarmTime
        self.date = nil
        self.time = routine.time?.convertToString(formatType: .time24Hour)
        self.repeatDays = routine.repeatDays
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
        self.categoryIcon = schedule.categoryIcon
        self.categoryColor = schedule.category.colorHex.convertToUIColor() ?? .white
        self.alarmTime = schedule.alarmTime
        self.date = nil
        self.time = schedule.time?.convertToString(formatType: .time24Hour)
        self.repeatDays = schedule.repeatDays
        self.place = schedule.place
        self.isPublic = false
        self.memo = schedule.memo
        self.isFinished = schedule.isFinished
        self.isRepeating = false
        self.eventMode = schedule.eventMode
    }
}
