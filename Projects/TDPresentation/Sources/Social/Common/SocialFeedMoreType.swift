import TDDesign
import UIKit

enum SocialFeedMoreType: String, CaseIterable {
    case report = "신고"
    case block = "차단"

    var image: TDDropdownItem.SelectableImage? {
        switch self {
        case .report:
            (TDImage.reportEmptySmall, TDImage.reportFillSmall)
        case .block:
            (TDImage.banEmptySmall, TDImage.banFillSmall)
        }
    }

    var dropdownItem: TDDropdownItem {
        TDDropdownItem(
            title: rawValue,
            leftImage: nil,
            rightImage: image
        )
    }
}
