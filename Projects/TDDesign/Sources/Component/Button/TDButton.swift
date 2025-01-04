import SnapKit
import UIKit

public final class TDButton: TDBaseButton {
    var size: TDButtonSize!

    public init(
        frame: CGRect = .zero,
        title: String,
        size: TDButtonSize = .medium,
        foregroundColor: UIColor = .white,
        backgroundColor: UIColor = TDColor.Primary.primary500
    ) {
        self.size = size

        super.init(
            title: title,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            radius: size.radius,
            font: size.font
        )
    }
}
