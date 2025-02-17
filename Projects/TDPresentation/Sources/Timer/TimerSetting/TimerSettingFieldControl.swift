import TDDesign
import UIKit

final class TimerSettingFieldControl: UIControl {
    private let titleLabel = TDLabel(toduckFont: .mediumBody2).then {
        $0.textAlignment = .center
    }

    let outputLabel = TDLabel(toduckFont: .mediumBody2).then {
        $0.textAlignment = .center
    }

    let leftButton = UIButton(type: .custom).then {
        $0.setImage(TDImage.Direction.leftMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = TDColor.Neutral.neutral600
    }

    let rightButton = UIButton(type: .custom).then {
        $0.setImage(TDImage.Direction.rightMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = TDColor.Neutral.neutral600
    }

    // MARK: - Initializers

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        addView()
        layout()
    }

    convenience init(state: TimerSettingView.TimerSettingFieldState) {
        self.init(title: state.rawValue)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addView() {
        addSubview(titleLabel)
        addSubview(outputLabel)
        addSubview(leftButton)
        addSubview(rightButton)
    }

    func layout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.size.equalTo(LayoutConstant.buttonSize)
        }

        outputLabel.snp.makeConstraints { make in
            make.width.equalTo(LayoutConstant.outputLabelWidth)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading).offset(LayoutConstant.outputGap)
        }

        leftButton.snp.makeConstraints { make in
            make.size.equalTo(LayoutConstant.buttonSize)
            make.trailing.equalTo(outputLabel.snp.leading).offset(LayoutConstant.outputGap)
        }
    }
}

private extension TimerSettingFieldControl {
    enum LayoutConstant {
        static let buttonSize = 24
        static let outputLabelWidth = 82
        static let outputGap = -8
    }
}
