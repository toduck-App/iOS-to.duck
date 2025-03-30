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
            (TDImage.Pen.penMediumColor, TDImage.Pen.penPrimaryColor)
        case .delete:
            (TDImage.trashMedium, TDImage.trashMedium)
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
