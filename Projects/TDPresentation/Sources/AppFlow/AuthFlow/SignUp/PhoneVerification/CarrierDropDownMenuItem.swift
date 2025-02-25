import TDDesign

enum CarrierDropDownMenuItem: String, CaseIterable {
    case kt = "KT"
    case lg = "LG U+"
    case skt = "SKT"
    case ktCheap = "KT 알뜰폰"
    case lgCheap = "LG U+ 알뜰폰"
    case sktCheap = "SKT 알뜰폰"
    
    var dropDownItem: TDDropdownItem {
        return TDDropdownItem(title: rawValue)
    }
}
