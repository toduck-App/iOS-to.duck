import UIKit
import TDDomain

extension Eventable {
    var categoryColor: UIColor {
        return category.colorHex.convertToUIColor() ?? .clear
    }
    
    var categoryIcon: UIImage? {
        return UIImage.categoryDictionary[category.imageName]
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
