import TDCore
import TDDesign
import UIKit

final class DeleteEventViewController: TDPopupViewController<DeleteEventView> {
    enum Mode {
        case single
        case repeating
    }
    
    private let mode: Mode
    
    init(isRepeating: Bool) {
        self.mode = isRepeating ? .repeating : .single
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }
}
