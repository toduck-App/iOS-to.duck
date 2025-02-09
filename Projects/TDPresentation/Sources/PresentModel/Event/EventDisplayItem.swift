import UIKit

/// TDDomain의 일정과 루틴을 표현하기 위한 Presentation Model
struct EventDisplayItem: EventPresentable {
    let id: Int?
    let title: String
    let time: String?
    let memo: String?
    let categoryIcon: UIImage?
    let categoryColor: UIColor
    var isFinish: Bool
    let place: String?
    
    init(
        id: Int?,
        title: String,
        time: String?,
        memo: String?,
        categoryIcon: UIImage?,
        categoryColor: UIColor,
        isFinished: Bool,
        place: String?
    ) {
        self.id = id
        self.title = title
        self.time = time
        self.memo = memo
        self.categoryIcon = categoryIcon
        self.categoryColor = categoryColor
        self.isFinish = isFinished
        self.place = place
    }
    
    init(from event: EventPresentable) {
        self.id = event.id
        self.title = event.title
        self.time = event.time
        self.memo = event.memo
        self.categoryIcon = event.categoryIcon
        self.categoryColor = event.categoryColor
        self.isFinish = event.isFinish
        self.place = nil
    }
    
    func configurePlace(_ place: String) -> EventDisplayItem {
        return EventDisplayItem(
            id: id,
            title: title,
            time: time,
            memo: memo,
            categoryIcon: categoryIcon,
            categoryColor: categoryColor,
            isFinished: isFinish,
            place: place
        )
    }
}
