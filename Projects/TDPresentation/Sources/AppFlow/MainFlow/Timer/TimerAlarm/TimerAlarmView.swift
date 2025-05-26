import UIKit
import TDDesign

final class TimerAlarmView: BaseView {
    let exitButton: TDBaseButton = TDBaseButton(image: TDImage.X.x1Medium, backgroundColor: .clear,foregroundColor: TDColor.Neutral.neutral700)

    let titleLabel = TDLabel(
        labelText: "알림 설정", toduckFont: .boldHeader4, alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )

    let muteAlarmButton = TimerAlarmControl(alarmType: .mute)
    let soundAlarmButton = TimerAlarmControl(alarmType: .sound)
    let vibrationAlarmButton = TimerAlarmControl(alarmType: .vibration)
    let systemAlarmButton = TimerAlarmControl(alarmType: .system)

    let alarmStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 12
    }

    let saveButton: TDButton = .init(title: "저장", size: .large)

    override func configure() {
        systemAlarmButton.isSelected = true
    }

    override func addview() {
        addSubview(exitButton)
        addSubview(titleLabel)
        addSubview(alarmStackView)
        addSubview(saveButton)

        [muteAlarmButton, soundAlarmButton, vibrationAlarmButton, systemAlarmButton].forEach { 
            alarmStackView.addArrangedSubview($0)
        }
    }

    override func layout() {
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutConstant.exitButtonLeading)
            make.top.equalToSuperview().inset(LayoutConstant.exitButtonTop)
            make.size.equalTo(LayoutConstant.exitButtonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
        }

        alarmStackView.snp.makeConstraints { make in
            make.leading.equalTo(exitButton.snp.leading)
            make.trailing.equalToSuperview().inset(LayoutConstant.alarmStackViewTrailing)
            make.top.equalTo(exitButton.snp.bottom).offset(LayoutConstant.alarmStackViewTop)
        }

        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(alarmStackView.snp.leading)
            make.trailing.equalTo(alarmStackView.snp.trailing)
            make.height.equalTo(LayoutConstant.saveButtonHeight)
            make.top.equalTo(systemAlarmButton.snp.bottom).offset(LayoutConstant.saveButtonTop)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutConstant.saveButtonBottom).priority(750)
        }

        [muteAlarmButton, soundAlarmButton, vibrationAlarmButton, systemAlarmButton].forEach { button in
            button.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(52)
            }
        }
    }
}


extension TimerAlarmView {
    enum LayoutConstant {
        static let exitButtonSize: CGFloat = 24
        static let exitButtonLeading: CGFloat = 16
        static let exitButtonTop: CGFloat = 24

        static let alarmStackViewTrailing: CGFloat = 16
        static let alarmStackViewTop: CGFloat = 42

        static let saveButtonHeight: CGFloat = 56
        static let saveButtonTop: CGFloat = 36
        static let saveButtonBottom: CGFloat = 16
    }
}
