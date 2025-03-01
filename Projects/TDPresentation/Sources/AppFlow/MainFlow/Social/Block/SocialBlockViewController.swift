import UIKit

final class SocialBlockViewController: TDPopupViewController<SocialBlockView> {
    var onBlock: (() -> Void)?
    
    override func configure() {
        super.configure()
        popupContentView.blockButton.addAction(UIAction { [weak self] _ in
            self?.onBlock?()
            self?.dismissPopup()
        }, for: .touchUpInside)
        
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }
}
