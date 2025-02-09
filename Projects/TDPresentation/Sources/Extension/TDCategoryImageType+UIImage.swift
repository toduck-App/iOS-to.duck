import UIKit
import TDDesign
import TDDomain

extension TDCategoryImageType {
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "computer": self = .computer
        case "food": self = .food
        case "pencil": self = .pencil
        case "redbook": self = .redBook
        case "yellowbook": self = .yellowBook
        case "sleep": self = .sleep
        case "power": self = .power
        case "people": self = .people
        case "medicine": self = .medicine
        case "talk": self = .talk
        case "vehicle": self = .vehicle
        default: self = .none
        }
    }
    
    var image: UIImage {
        switch self {
        case .computer: TDImage.Category.computer
        case .food: TDImage.Category.food
        case .pencil: TDImage.Category.pencil
        case .redBook: TDImage.Category.redBook
        case .yellowBook: TDImage.Category.yellowBook
        case .sleep: TDImage.Category.sleep
        case .power: TDImage.Category.power
        case .people: TDImage.Category.people
        case .medicine: TDImage.Category.medicine
        case .talk: TDImage.Category.talk
        case .vehicle: TDImage.Category.vehicle
        case .none: TDImage.Category.none
        }
    }
}
