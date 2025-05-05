import TDDesign
import UIKit

final class NotificationSettingView: BaseView {
    let pushSettingLabel = TDLabel(
        labelText: "푸쉬 알림 설정",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let settingContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
    }.then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.cornerRadius = 12
    }
    
    let onOffContainer = UIView()
    
    let onOffLabel = TDLabel(
        labelText: "OFF / ON",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let onOffSwitch = TDToggle() // MARK: 현재 알림이 켜져있는지 확인하는 로직 필요
    
    let soundSettingContainer = UIView()
    
    let soundSettingLabel = TDLabel(
        labelText: "소리 / 진동",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let notificationsByFunctionContainer = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.cornerRadius = 12
    }
    
    let notificationsByFunctionLabel = TDLabel(
        labelText: "기능별 알림",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let soundSettingSegmentedControl =  UISegmentedControl(items: ["소리", "진동"]).then {
        $0.selectedSegmentIndex = 0
        
        $0.setTitleTextAttributes([
            .font: TDFont.mediumBody3.font,
            .foregroundColor: TDColor.Neutral.neutral500
        ], for: .normal)
        
        $0.setTitleTextAttributes([
            .font: TDFont.mediumBody3.font,
            .foregroundColor: TDColor.Neutral.neutral700
        ], for: .selected)
        
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.selectedSegmentTintColor = TDColor.baseWhite
    }
    
    override func addview() {
        addSubview(pushSettingLabel)
        addSubview(settingContainer)
        
        settingContainer.addArrangedSubview(onOffContainer)
        settingContainer.addArrangedSubview(soundSettingContainer)
        
        onOffContainer.addSubview(onOffLabel)
        onOffContainer.addSubview(onOffSwitch)
        
        soundSettingContainer.addSubview(soundSettingLabel)
        soundSettingContainer.addSubview(soundSettingSegmentedControl)
        
        addSubview(notificationsByFunctionContainer)
        notificationsByFunctionContainer.addSubview(notificationsByFunctionLabel)
    }
    
    override func layout() {
        pushSettingLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(36)
            $0.leading.trailing.equalToSuperview().offset(24)
        }
        
        settingContainer.snp.makeConstraints {
            $0.top.equalTo(pushSettingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        onOffContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        onOffLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        onOffSwitch.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        soundSettingContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        soundSettingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        soundSettingSegmentedControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(104)
            $0.height.equalTo(38)
            $0.centerY.equalToSuperview()
        }
        
        notificationsByFunctionContainer.snp.makeConstraints {
            $0.top.equalTo(settingContainer.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(64)
        }
        
        notificationsByFunctionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
