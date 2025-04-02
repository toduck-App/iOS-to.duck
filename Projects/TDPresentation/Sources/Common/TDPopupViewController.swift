import SnapKit
import TDDesign
import UIKit

/// 팝업을 위한 베이스 뷰 컨트롤러
class TDPopupViewController<PopupContentView: BaseView>: BaseViewController<BaseView>, UIGestureRecognizerDelegate {
    let popupContentView = PopupContentView()
    var isPopupPresent: Bool = false
    
    override func configure() {
        setupBackgroundDim()
        setupGestureRecognizer()
    }
    
    /// 배경을 어둡게 설정
    private func setupBackgroundDim() {
        view.backgroundColor = TDColor.baseBlack.withAlphaComponent(0.5)
    }
    
    /// 팝업을 닫을 수 있도록 제스처 추가
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        tapGesture.delegate = self
        layoutView.addGestureRecognizer(tapGesture)
        layoutView.isUserInteractionEnabled = true
    }
    
    override func addView() {
        layoutView.addSubview(popupContentView)
    }
    
    override func layout() {
        popupContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc
    func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    override func handleTapToDismiss() {
        if isPopupPresent {
            dismissPopup()
            isPopupPresent = false
        } else {
            view.endEditing(true)
        }
    }
    
    /// 팝업 외부 터치 시 닫히도록 설정
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
