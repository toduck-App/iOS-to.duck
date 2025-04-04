import TDDesign

enum DiaryEditType: String, CaseIterable {
    case edit = "수정"
    case delete = "삭제"
    
    var dropDownItem: TDDropdownItem {
        return TDDropdownItem(title: rawValue, rightImage: image)
    }
    
    var image: TDDropdownItem.SelectableImage {
        switch self {
        case .edit:
            return (TDImage.Pen.penNeutralColor, TDImage.Pen.penPrimaryColor)
        case .delete:
            return (TDImage.X.x2Medium, TDImage.X.x2Medium.withTintColor(TDColor.Primary.primary500))
        }
    }
}

