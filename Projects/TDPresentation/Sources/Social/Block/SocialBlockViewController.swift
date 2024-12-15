import UIKit

final class SocialBlockViewController: TDPopupViewController<SocialBlockView> {
    var onBlock: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        layerView.blockButton.addTarget(self, action: #selector(blockAction), for: .touchUpInside)
        layerView.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    @objc private func blockAction() {
        onBlock?()
        dismissPopup()
    }
    
    @objc private func cancelAction() {
        dismissPopup()
    }
}
