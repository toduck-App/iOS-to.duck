import TDDesign
import TDDomain

extension SocialSortType {
    var image: TDDropdownItem.SelectableImage? {
        switch self {
        case .recent:
            return (TDImage.Sort.recentEmpty, TDImage.Sort.recentFill)
        case .comment:
            return (TDImage.Sort.commentEmpty, TDImage.Sort.commentFill)
        case .sympathy:
            return (TDImage.Sort.sympathyEmpty, TDImage.Sort.sympathyFill)
        }
    }
    
    var dropdownItem: TDDropdownItem {
        return TDDropdownItem(
            title: rawValue,
            leftImage: image,
            rightImage: nil
        )
    }
}
