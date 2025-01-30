import TDDesign

enum SocialSortType: String, CaseIterable {
    case recent = "최신순"
    case comment = "댓글순"
    case sympathy = "공감순"
    
    var image: TDDropdownItem.SelectableImage? {
        switch self {
        case .recent:
            return (TDImage.Sort.recent, nil)
        case .comment:
            return (TDImage.Sort.comment, nil)
        case .sympathy:
            return (TDImage.Sort.sympathy, nil)
        }
    }
    
    var dropdownItem: TDDropdownItem {
        return TDDropdownItem(
            title: rawValue,
            leftImage: nil,
            rightImage: nil
        )
    }
}
