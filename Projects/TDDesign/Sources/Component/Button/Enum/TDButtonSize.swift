import UIKit

public enum TDButtonSize {
    case small // 40
    case mediumSmall // 48
    case medium // 52
    case large // 56

    var height: CGFloat {
        switch self {
        case .small:
            return 32
        case .mediumSmall:
            return 48
        case .medium:
            return 52
        case .large:
            return 56
        }
    }

    var radius: CGFloat {
        switch self {
        case .small:
            return 8
        case .mediumSmall,
             .medium,
             .large:
            return 12
        }
    }

    var font: UIFont {
        switch self {
        case .small:
            return TDFont.boldBody2.font
        case .mediumSmall,
             .medium,
             .large:
            return TDFont.boldHeader3.font
        }
    }
}
