import UIKit

final class NotificationSettingViewController: BaseViewController<NotificationSettingView> {
    weak var coordinator: NotificationSettingCoordinator?
        
    override func configure() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "알림 설정",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
        
        layoutView.notificationsByFunctionContainer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapNotificationsByFunction))
        )
    }
    
    @objc private func didTapNotificationsByFunction() {
        coordinator?.didTapNotificationByFunction()
    }
}
