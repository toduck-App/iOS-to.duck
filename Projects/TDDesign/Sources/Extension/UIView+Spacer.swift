import UIKit
import SnapKit
import Then

extension UIView {
    static func spacer(height: CGFloat) -> UIView {
        return UIView().then {
            $0.snp.makeConstraints { $0.height.equalTo(height) }
        }
    }
}
