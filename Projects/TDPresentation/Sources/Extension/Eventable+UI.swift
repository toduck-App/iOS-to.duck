import UIKit
import TDDomain

extension Eventable {
    var categoryColor: UIColor {
        return category.colorHex.convertToUIColor() ?? .clear
    }
    
    var categoryIcon: UIImage? {
        return UIImage.categoryDictionary[category.imageName]
    }
}
