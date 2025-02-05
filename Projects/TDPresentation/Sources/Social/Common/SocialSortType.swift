import TDDesign

enum SocialSortType: String, CaseIterable {
    case recent = "최신순"
    case comment = "댓글순"
    case sympathy = "공감순"
    
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
            leftImage: nil,
            rightImage: image
        )
    }
}
