import UIKit
import TDDomain

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: Eventable {
    let id: Int?
    let title: String
    let category: TDCategory
    let isAllDay: Bool
    let time: String?
    let isRepeating: Bool
    let repeatDays: [TDWeekDay]?
    let alarmTime: AlarmTime?
    let memo: String?
    let isFinished: Bool
    let eventMode: TDEventMode
    
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    let date: String?
    let place: String?
    let isPublic: Bool
    
    init(
        from event: any Eventable,
        place: String? = nil,
        date: String? = nil,
        isPublic: Bool = false
    ) {
        self.id = event.id
        self.title = event.title
        self.category = event.category
        self.isAllDay = event.isAllDay
        self.time = event.time
        self.isRepeating = event.isRepeating
        self.repeatDays = event.repeatDays
        self.alarmTime = event.alarmTime
        self.memo = event.memo
        self.isFinished = event.isFinished
        self.eventMode = event.eventMode
        
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.date = date
        self.place = place
        self.isPublic = isPublic
    }
    
    init(routine: Routine) {
        self.id = routine.id
        self.title = routine.title
        self.category = routine.category
        self.isAllDay = routine.isAllDay
        self.time = routine.time
        self.isRepeating = routine.isRepeating
        self.repeatDays = routine.repeatDays
        self.alarmTime = routine.alarmTime
        self.memo = routine.memo
        self.isFinished = routine.isFinished
        self.eventMode = routine.eventMode
        
        self.categoryIcon = routine.categoryIcon
        self.categoryColor = routine.category.colorHex.convertToUIColor() ?? .white
        self.date = nil
        self.place = nil
        self.isPublic = routine.isPublic
    }
    
    init(schedule: Schedule) {
        self.id = schedule.id
        self.title = schedule.title
        self.category = schedule.category
        self.isAllDay = schedule.isAllDay
        self.time = schedule.time
        self.isRepeating = false
        self.repeatDays = schedule.repeatDays
        self.alarmTime = schedule.alarmTime
        self.memo = schedule.memo
        self.isFinished = schedule.isFinished
        self.eventMode = schedule.eventMode
        
        self.categoryIcon = schedule.categoryIcon
        self.categoryColor = schedule.category.colorHex.convertToUIColor() ?? .white
        self.date = nil
        self.place = schedule.place
        self.isPublic = false
    }
}
