import TDDesign
import UIKit

final class NotificationViewController: BaseViewController<BaseView>, UIGestureRecognizerDelegate {
    weak var coordinator: NotificationCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = TDLabel(
            labelText: "알람 화면",
            toduckFont: .mediumHeader5,
            toduckColor: TDColor.Neutral.neutral600
        )
        layoutView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
