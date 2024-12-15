import UIKit

final class TimerViewController: BaseViewController<TimerView> {
    weak var coordinator: TimerCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(style: .timer, navigationDelegate: coordinator!)
        layoutView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        let vc = TimerSettingViewController()
    
        // vc.modalPresentationStyle = .custom
        // vc.transitioningDelegate = delegate
        // present(vc, animated: true)
    }

    
}
