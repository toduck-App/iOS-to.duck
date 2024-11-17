import TDDesign
import UIKit

enum SocialFeedMoreType: String, CaseIterable {
    case report = "신고"
    case block = "차단"
    
    var leftImage: UIImage? {
        switch self {
        case .report:
            return TDImage.reportMedium
        case .block:
            return TDImage.X.x2Medium
        }
    }
    
    var dropdownItem: TDDropdownItem {
        return TDDropdownItem(
            title: rawValue,
            leftImage: leftImage,
            rightImage: nil
        )
    }
}
