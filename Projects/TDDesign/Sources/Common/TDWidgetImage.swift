import SwiftUI

public enum TDWidgetImage {
    public enum Diary {
        public static let A1 = TDDesignAsset.Images.widgetA1.swiftUIImage
        public static let A2 = TDDesignAsset.Images.widgetA2.swiftUIImage
        public static let A3 = TDDesignAsset.Images.widgetA3.swiftUIImage
        public static let B1 = TDDesignAsset.Images.widgetB1.swiftUIImage
        public static let B2 = TDDesignAsset.Images.widgetB2.swiftUIImage
        public static let B3 = TDDesignAsset.Images.widgetB3.swiftUIImage
        public static let C1 = TDDesignAsset.Images.widgetC1.swiftUIImage
        public static let C2 = TDDesignAsset.Images.widgetC2.swiftUIImage
        public static let C3 = TDDesignAsset.Images.widgetC3.swiftUIImage
        public static let D1 = TDDesignAsset.Images.widgetD1.swiftUIImage
        public static let D2 = TDDesignAsset.Images.widgetD2.swiftUIImage
        public static let D3 = TDDesignAsset.Images.widgetD3.swiftUIImage
    }
    
    public enum Schedule {
        public static let noSchedule = TDDesignAsset.Images.widgetNoSchedule.swiftUIImage
    }
    
    public enum Category {
        case food
        case none
        case talk
        case heart
        case power
        case sleep
        case pencil
        case people
        case redBook
        case vehicle
        case computer
        case medicine
        case yellowBook
        
        public init(_ name: String) {
            let name = name.lowercased()
            switch name {
            case "food": self = .food
            case "none": self = .none
            case "talk": self = .talk
            case "heart": self = .heart
            case "power": self = .power
            case "sleep": self = .sleep
            case "pencil": self = .pencil
            case "people": self = .people
            case "redBook": self = .redBook
            case "vehicle": self = .vehicle
            case "computer": self = .computer
            case "medicine": self = .medicine
            case "yellowBook": self = .yellowBook
            default: self = .none
            }
        }
        
        public var swiftUIImage: SwiftUI.Image {
            switch self {
            case .food:
                TDDesignAsset.Images.categoryFood.swiftUIImage
            case .none:
                TDDesignAsset.Images.categoryNone.swiftUIImage
            case .talk:
                TDDesignAsset.Images.categoryTalk.swiftUIImage
            case .heart:
                TDDesignAsset.Images.categoryHeart.swiftUIImage
            case .power:
                TDDesignAsset.Images.categoryPower.swiftUIImage
            case .sleep:
                TDDesignAsset.Images.categorySleep.swiftUIImage
            case .pencil:
                TDDesignAsset.Images.categoryPencil.swiftUIImage
            case .people:
                TDDesignAsset.Images.categoryPeople.swiftUIImage
            case .redBook:
                TDDesignAsset.Images.categoryRedbook.swiftUIImage
            case .vehicle:
                TDDesignAsset.Images.categoryVehicle.swiftUIImage
            case .computer:
                TDDesignAsset.Images.categoryComputer.swiftUIImage
            case .medicine:
                TDDesignAsset.Images.categoryMedicine.swiftUIImage
            case .yellowBook:
                TDDesignAsset.Images.categoryYellowbook.swiftUIImage
            }
        }
    }
    
    public static let tomato = TDDesignAsset.Images.widgetTomato.swiftUIImage
    public static let error = TDDesignAsset.Images.widgetError.swiftUIImage
}
