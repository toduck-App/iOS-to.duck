import UIKit
import TDDesign

final class TimerCautionPopupViewController: TDPopupViewController<TimerCautionPopupView> {
    enum PopupMode {
        case stop
        case reset
    }
    
    var onAction: (() -> Void)?
    var popupMode: PopupMode
    
    init(popupMode: PopupMode) {
        self.popupMode = popupMode
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        showPopupMode(mode: popupMode)
        popupContentView.actionButton.addAction(UIAction { [weak self] _ in
            self?.onAction?()
            self?.dismissPopup()
        }, for: .touchUpInside)
        
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }
    
    func showPopupMode(mode: PopupMode) {
        switch mode {
        case .stop:
            popupContentView.popupImageView.image = TDImage.Alert.deleteEvent
            popupContentView.popupTitleLabel.setText("현재 세트를 종료할까요?")
            popupContentView.descriptionLabel.setText("집중 기록은 저장되고, 현재 흐름은 마무리돼요.")
            popupContentView.actionButton.updateTitle("종료")
        case .reset:
            popupContentView.popupImageView.image = TDImage.timerAlert
            popupContentView.popupTitleLabel.setText("타이머를 다시 시작할까요?")
            popupContentView.descriptionLabel.setText("완료된 집중 횟수는 유지되고, 시간만 새로 시작돼요.")
            popupContentView.actionButton.updateTitle("재시작")
        }
    }
}
