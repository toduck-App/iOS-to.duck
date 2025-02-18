import Combine
import UIKit
import TDCore
import TDDesign

final class PhoneVerificationViewController: BaseViewController<PhoneVerificationView> {
    weak var coordinator: PhoneVerificationCoordinator?
    
    override func configure() {
        layoutView.carrierDropDownView.delegate = self
        layoutView.carrierDropDownView.dataSource = CarrierDropDownMenuItem.allCases.map { $0.dropDownItem }
    }
}

// MARK: - TDDropDownDelegate
extension PhoneVerificationViewController: TDDropDownDelegate {    
    func dropDown(
        _ dropDownView: TDDropdownHoverView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let option = CarrierDropDownMenuItem.allCases[indexPath.row]
        layoutView.dropDownAnchorView.setTitle(option.rawValue)
    }
}

