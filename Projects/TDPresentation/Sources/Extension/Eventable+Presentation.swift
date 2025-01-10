import UIKit
import TDDomain

protocol EventPresentable {
    var id: UUID { get }
    var title: String { get }
    var memo: String? { get }
    var categoryIcon: UIImage? { get }
    var categoryColor: UIColor { get }
    var time: String? { get }
    var isFinish: Bool { get }
}

extension Eventable {
    var categoryColor: UIColor {
        return category.colorHex.convertToUIColor() ?? .clear
    }
    
    var categoryIcon: UIImage? {
        return UIImage.categoryDictionary[category.imageIndex]
    }
    
    var time: String? {
        guard let eventTime = self.time else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: eventTime)
    }
}

extension Schedule: EventPresentable {}
extension Routine: EventPresentable {}
