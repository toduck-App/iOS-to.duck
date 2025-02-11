import UIKit
import TDCore

final class MyPageViewController: BaseViewController<MyPageView> {
    weak var coordinator: MyPageCoordinator?
    
    override func addView() {
        setupNavigationBar(style: .mypage, navigationDelegate: coordinator!) {
            TDLogger.debug("MyPageViewController - setupNavigationBar")
        }
    }
    
    override func layout() {
        self.view.backgroundColor = .white
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let responderEvent = event as? CustomEventWrapper {
            if responderEvent.customType == .profileImageTapped {
                coordinator?.didTapProfileButton()
            }
        }
    }
}
