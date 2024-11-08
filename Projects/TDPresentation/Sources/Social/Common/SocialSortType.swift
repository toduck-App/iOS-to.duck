import TDDesign

enum SocialSortType: String, CaseIterable {
    case recent = "최신순"
    case comment = "댓글순"
    case sympathy = "공감순"
    
    var dropdownItem: TDDropdownItem {
        return TDDropdownItem(
            title: rawValue,
            leftImage: nil,
            rightImage: nil
        )
    }
}
