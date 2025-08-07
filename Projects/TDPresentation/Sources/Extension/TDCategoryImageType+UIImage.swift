import UIKit
import TDDesign
import TDDomain

extension TDCategoryImageType {
    init(rawValue: String) {
        switch rawValue.uppercased() {
        case "COMPUTER": self = .computer
        case "FOOD": self = .food
        case "PENCIL": self = .pencil
        case "RED_BOOK": self = .redBook
        case "SLEEP": self = .sleep
        case "POWER": self = .power
        case "PEOPLE": self = .people
        case "MEDICINE": self = .medicine
        case "TALK": self = .talk
        case "HEART": self = .heart
        case "VEHICLE": self = .vehicle
        default: self = .`default`
        }
    }
    
    var image: UIImage {
        switch self {
        case .computer: TDImage.Category.computer
        case .food: TDImage.Category.food
        case .pencil: TDImage.Category.pencil
        case .redBook: TDImage.Category.redBook
        case .sleep: TDImage.Category.sleep
        case .power: TDImage.Category.power
        case .people: TDImage.Category.people
        case .medicine: TDImage.Category.medicine
        case .talk: TDImage.Category.talk
        case .heart: TDImage.Category.heart
        case .vehicle: TDImage.Category.vehicle
        case .`default`: TDImage.Category.none
        case .none: TDImage.Category.none
        }
    }
}
