import TDDesign
import UIKit

final class NotificationSettingView: BaseView {
    let pushSettingLabel = TDLabel(
        labelText: "알림 설정",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let alarmOnOffContainer = UIView()
    let alarmOnOffLabel = TDLabel(
        labelText: "푸시 알림",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    let alarmOnOffSwitch = TDToggle() // MARK: 현재 알림이 켜져있는지 확인하는 로직 필요

    
    let silentOnOffContainer = UIView()
    let silentOnOffLabel = TDLabel(
        labelText: "무음",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    let silentOnOffSwitch = TDToggle() // MARK: 현재 알림이 켜져있는지 확인하는 로직 필요

    override func addview() {
        addSubview(pushSettingLabel)
        addSubview(alarmOnOffContainer)
        alarmOnOffContainer.addSubview(alarmOnOffLabel)
        alarmOnOffContainer.addSubview(alarmOnOffSwitch)
        
        addSubview(silentOnOffContainer)
        silentOnOffContainer.addSubview(silentOnOffLabel)
        silentOnOffContainer.addSubview(silentOnOffSwitch)
    }
    
    override func layout() {
        pushSettingLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(36)
            $0.leading.trailing.equalToSuperview().offset(24)
        }
        
        alarmOnOffContainer.snp.makeConstraints {
            $0.top.equalTo(pushSettingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(64)
        }
        alarmOnOffLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        alarmOnOffSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        silentOnOffContainer.snp.makeConstraints {
            $0.top.equalTo(alarmOnOffContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(64)
        }
        silentOnOffLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        silentOnOffSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func configure() {
        alarmOnOffContainer.backgroundColor = TDColor.baseWhite
        alarmOnOffContainer.layer.cornerRadius = 12
        silentOnOffContainer.backgroundColor = TDColor.baseWhite
        silentOnOffContainer.layer.cornerRadius = 12
    }
}
