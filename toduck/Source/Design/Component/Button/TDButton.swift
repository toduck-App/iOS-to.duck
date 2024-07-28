import Foundation
import SnapKit
import UIKit

public enum TDButtonSize {
    case small
    case medium

    var height: CGFloat {
        switch self {
        case .small:
            return 32
        case .medium:
            return 54
        }
    }

    var radius: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 12
        }
    }

    var font: UIFont {
        switch self {
        case .small:
            return TDFont.boldBody2.font
        case .medium:
            return TDFont.boldHeader3.font
        }
    }
}

public final class TDButton: TDBaseButton {
    var size: TDButtonSize!

    public init(frame: CGRect = .zero,
                title: String,
                size: TDButtonSize = .medium,
                foregroundColor: UIColor = .white,
                backgroundColor: UIColor = TDColor.Primary.primary500)
    {
        self.size = size

        super.init(frame: frame,
                   title: title,
                   backgroundColor: backgroundColor,
                   foregroundColor: foregroundColor,
                   radius: size.radius,
                   font: size.font)
    }

    required init?(coder _: NSCoder) {
        super.init(frame: .zero)
    }

    override func layout() {
        snp.updateConstraints {
            $0.height.equalTo(size.height)
        }
    }
}
