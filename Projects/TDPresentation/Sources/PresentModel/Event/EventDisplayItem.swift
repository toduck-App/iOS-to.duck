import UIKit

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: EventPresentable {
    let id: Int?
    let title: String
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    let alarmTimes: [String]?
    let date: String?
    let time: String?
    let repeatDays: String?
    let place: String?
    let memo: String?
    let isFinished: Bool
    let isRepeating: Bool
    
    init(
        id: Int?,
        title: String,
        categoryIcon: UIImage?,
        categoryColor: UIColor,
        alarmTimes: [String]?,
        date: String?,
        time: String?,
        repeatDays: String?,
        place: String?,
        memo: String?,
        isFinished: Bool,
        isRepeating: Bool
    ) {
        self.id = id
        self.title = title
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.alarmTimes = alarmTimes
        self.date = date
        self.time = time
        self.repeatDays = repeatDays
        self.place = place
        self.memo = memo
        self.isFinished = isFinished
        self.isRepeating = isRepeating
    }
    
    init(
        from event: EventPresentable,
        alarmTimes: [String]? = nil,
        date: String? = nil,
        repeatDays: String? = nil,
        place: String? = nil
    ) {
        self.id = event.id
        self.title = event.title
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.alarmTimes = alarmTimes
        self.date = date
        self.time = event.time
        self.repeatDays = repeatDays
        self.memo = event.memo
        self.place = place
        self.isFinished = event.isFinished
        self.isRepeating = event.isRepeating
    }
}
