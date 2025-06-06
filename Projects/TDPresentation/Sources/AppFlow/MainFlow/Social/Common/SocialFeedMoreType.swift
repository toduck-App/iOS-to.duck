import TDDesign
import UIKit

enum SocialFeedMoreType: String, CaseIterable {
    case report = "신고"
    case block = "차단"
    case edit = "수정"
    case delete = "삭제"

    var image: TDDropdownItem.SelectableImage? {
        switch self {
        case .report:
            (TDImage.reportEmptySmall, TDImage.reportFillSmall)
        case .block:
            (TDImage.banEmptySmall, TDImage.banFillSmall)
        case .edit:
            (TDImage.Pen.penNeutralColor, TDImage.Pen.penPrimaryColor)
        case .delete:
            (TDImage.X.x2Medium, TDImage.X.x2Medium.withTintColor(TDColor.Primary.primary500))
        }
    }

    var dropdownItem: TDDropdownItem {
        TDDropdownItem(
            title: rawValue,
            leftImage: image,
            rightImage: nil
        )
    }
}
