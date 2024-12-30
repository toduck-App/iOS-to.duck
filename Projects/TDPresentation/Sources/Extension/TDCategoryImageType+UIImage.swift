import UIKit
import TDDesign
import TDDomain

extension TDCategoryImageType {
    var image: UIImage {
        switch self {
        case .computer:
            return TDImage.Category.computer
        case .food:
            return TDImage.Category.food
        case .pencil:
            return TDImage.Category.pencil
        case .redBook:
            return TDImage.Category.redBook
        case .yellowBook:
            return TDImage.Category.yellowBook
        case .sleep:
            return TDImage.Category.sleep
        case .power:
            return TDImage.Category.power
        case .people:
            return TDImage.Category.people
        case .medicine:
            return TDImage.Category.medicine
        case .talk:
            return TDImage.Category.talk
        case .vehicle:
            return TDImage.Category.vehicle
        case .none:
            return TDImage.Category.none
        }
    }
}
