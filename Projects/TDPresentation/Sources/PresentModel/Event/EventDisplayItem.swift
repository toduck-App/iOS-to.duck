import UIKit

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: EventPresentable {
    let id: Int?
    let title: String
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    let time: String?
    let memo: String?
    let isFinished: Bool
    let isRepeating: Bool
    let place: String?
    
    init(
        id: Int?,
        title: String,
        categoryIcon: UIImage?,
        categoryColor: UIColor,
        time: String?,
        memo: String?,
        isFinished: Bool,
        isRepeating: Bool,
        place: String?
    ) {
        self.id = id
        self.title = title
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.time = time
        self.memo = memo
        self.isFinished = isFinished
        self.isRepeating = isRepeating
        self.place = place
    }
    
    init(
        from event: EventPresentable,
        place: String? = nil
    ) {
        self.id = event.id
        self.title = event.title
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.time = event.time
        self.memo = event.memo
        self.isFinished = event.isFinished
        self.isRepeating = event.isRepeating
        self.place = place
    }
}
