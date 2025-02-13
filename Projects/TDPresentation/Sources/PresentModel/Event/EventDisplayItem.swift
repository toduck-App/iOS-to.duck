import UIKit

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: EventPresentable {
    let id: Int?
    let title: String
    let time: String?
    let memo: String?
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    let isFinished: Bool
    let place: String?
    let isRepeating: Bool
    
    init(
        id: Int?,
        title: String,
        time: String?,
        memo: String?,
        categoryIcon: UIImage?,
        categoryColor: UIColor,
        isFinished: Bool,
        place: String?,
        isRepeating: Bool
    ) {
        self.id = id
        self.title = title
        self.time = time
        self.memo = memo
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.isFinished = isFinished
        self.place = place
        self.isRepeating = isRepeating
    }
    
    init(
        from event: EventPresentable,
        place: String? = nil
    ) {
        self.id = event.id
        self.title = event.title
        self.time = event.time
        self.memo = event.memo
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.isFinished = event.isFinished
        self.isRepeating = event.isRepeating
        self.place = place
    }
}
