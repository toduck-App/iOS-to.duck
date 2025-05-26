import TDDesign
import UIKit

final class TimerAlarmControl: UIControl {
    let label = TDLabel(toduckFont: .mediumHeader5,toduckColor: TDColor.Neutral.neutral600)
        .then {
            $0.textAlignment = .left
        }
    let alarmType: TimerAlarmType
    override var isSelected: Bool {
        didSet {
            if isSelected {
                active()
            } else {
                deactive()
            }
        }
    }

    init(frame: CGRect = .zero, alarmType: TimerAlarmType) {
        self.alarmType = alarmType
        super.init(frame: frame)
        configure()
        addview()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        layer.borderWidth = 0
        layer.cornerRadius = 12

        label.setText(alarmType.title)
    }

    func addview() {
        addSubview(label)
    }

    func layout() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }

    func active() {
        backgroundColor = TDColor.Primary.primary50

        label.setFont(TDFont.boldHeader5)
        label.setColor(TDColor.Primary.primary500)
    }

    func deactive() {
        backgroundColor = .clear

        label.setFont(TDFont.mediumHeader5)
        label.setColor(TDColor.Neutral.neutral600)
    }
}

extension TimerAlarmControl {
    enum TimerAlarmType {
        case mute
        case sound
        case vibration
        case system

        var title: String {
            switch self {
            case .mute:
                return "무음"
            case .sound:
                return "소리 알람"
            case .vibration:
                return "진동 알람"
            case .system:
                return "시스템 알람"
            }
        }
    }
}