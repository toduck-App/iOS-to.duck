import UIKit
import TDDesign
import TDCore
import UserNotifications

final class NotificationSettingViewController: BaseViewController<NotificationSettingView> {
    weak var coordinator: NotificationSettingCoordinator?
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncPushToggleState()
    }
    
    private func syncPushToggleState() {
        LocalPushNotificationManager.shared.checkAuthorization { [weak self] isAuthorized in
            guard let self else { return }
            let isPushEnabled = UserDefaults.standard.bool(forKey: UserDefaultsConstant.pushEnabledKey)
            let isSilent = UserDefaults.standard.bool(forKey: UserDefaultsConstant.pushSilentKey)
            
            self.layoutView.alarmOnOffSwitch.isOn = isAuthorized && isPushEnabled
            self.layoutView.silentOnOffSwitch.isOn = isSilent
        }
    }
    
    // MARK: - Common Methods
    override func configure() {
        setupAction()
        setupNavigationBar()
    }
    
    private func setupAction() {
        layoutView.alarmOnOffSwitch.addTarget(
            self,
            action: #selector(didTogglePushSwitch(_:)),
            for: .valueChanged
        )
        
        layoutView.silentOnOffSwitch.addTarget(
            self,
            action: #selector(didToggleSilentSwitch(_:)),
            for: .valueChanged
        )
    }
    
    @objc
    private func didTogglePushSwitch(_ sender: UISwitch) {
        if sender.isOn {
            LocalPushNotificationManager.shared.requestAuthorization { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    UserDefaults.standard.set(true, forKey: UserDefaultsConstant.pushEnabledKey)
                } else {
                    sender.isOn = false
                    self.promptToOpenSettings()
                }
            }
        } else {
            UserDefaults.standard.set(false, forKey: UserDefaultsConstant.pushEnabledKey)
            LocalPushNotificationManager.shared.removeAllScheduledNotifications()
        }
    }
    
    private func promptToOpenSettings() {
        showCommonAlert(
            title: "알림 설정",
            message: "알림을 받으려면 설정에서 권한을 허용해주세요.",
            cancelTitle: "취소",
            confirmTitle: "설정으로 이동"
        ) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        } onConfirm: {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc
    private func didToggleSilentSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsConstant.pushSilentKey)
    }
    
    private func setupNavigationBar() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "알림 설정",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
}
