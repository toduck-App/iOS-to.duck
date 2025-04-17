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
        return eventTime.convertToString(formatType: .time24Hour)
    }
}

extension Schedule: EventPresentable {}
extension Routine: EventPresentable {}
