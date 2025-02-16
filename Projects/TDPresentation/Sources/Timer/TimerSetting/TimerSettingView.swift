import TDDesign
import UIKit

final class TimerSettingView: BaseView {
    let recommandView = UIView().then { recommand in
        recommand.layer.borderWidth = 1
        recommand.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        recommand.layer.cornerRadius = 10

        let title = TDLabel(
            labelText: "토덕의 추천 설정", toduckFont: .boldBody2, alignment: .center,
            toduckColor: TDColor.Neutral.neutral800
        )

        let fireImageView = UIImageView().then {
            $0.image = TDImage.fireSmall
        }

        let recommandLabelStack = UIStackView().then {
            $0.spacing = 4
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }

        // addview
        recommand.addSubview(fireImageView)
        recommand.addSubview(title)
        recommand.addSubview(recommandLabelStack)

        for title in ["집중 횟수 4회", "집중 시간 25분", "휴식 시간 5분"] {
            let view = UIView().then {
                let label = TDLabel(toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
                label.setText(title)
                $0.backgroundColor = TDColor.Neutral.neutral50
                $0.layer.cornerRadius = 4

                $0.addSubview(label)
                label.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(8)
                }
            }
            recommandLabelStack.addArrangedSubview(view)
        }

        // layout
        fireImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }

        title.snp.makeConstraints { make in
            make.leading.equalTo(fireImageView.snp.trailing).inset(-4)
            make.centerY.equalTo(fireImageView.snp.centerY)
        }

        recommandLabelStack.snp.makeConstraints { make in
            make.top.equalTo(fireImageView.snp.bottom).offset(6)
            make.leading.equalTo(fireImageView.snp.leading)
        }
    }

    let exitButton = TDBaseButton(image: TDImage.X.x1Medium, backgroundColor: .clear)
    let timerSettingTitleLabel = TDLabel(
        labelText: "타이머 설정", toduckFont: .boldHeader4, alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    )

    let focusTimeField = TimerSettingFieldControl(state: .focusTime)
    let restTimeField = TimerSettingFieldControl(state: .focusCount)
    let focusCountField = TimerSettingFieldControl(state: .restTime)

    let fieldStack = UIStackView().then {
        $0.spacing = 28
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }

    let saveButton: TDButton = .init(title: "저장", size: .large)

    override func configure() {
        backgroundColor = .white
    }

    override func addview() {
        addSubview(exitButton)
        addSubview(timerSettingTitleLabel)
        addSubview(recommandView)

        for item in [focusTimeField, focusCountField, restTimeField] {
            fieldStack.addArrangedSubview(item)
        }

        addSubview(fieldStack)
        addSubview(saveButton)
    }

    override func layout() {
        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }

        timerSettingTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
        }

        recommandView.snp.makeConstraints { make in
            make.height.equalTo(86)
            make.leading.equalTo(exitButton.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(exitButton.snp.bottom).offset(45)
        }

        fieldStack.snp.makeConstraints { make in
            make.leading.equalTo(recommandView.snp.leading)
            make.trailing.equalTo(recommandView.snp.trailing)
            make.top.equalTo(recommandView.snp.bottom).offset(24)
        }

        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(recommandView.snp.leading)
            make.trailing.equalTo(recommandView.snp.trailing)
            make.height.equalTo(56)
            make.top.equalTo(fieldStack.snp.bottom).offset(36)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16).priority(750)
        }

        for field in [focusTimeField, focusCountField, restTimeField] {
            field.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
    }
}

extension TimerSettingView {
    // MARK: - TimerSettingFieldState

    public enum TimerSettingFieldState: String {
        case focusTime = "집중 시간"
        case restTime = "휴식 시간"
        case focusCount = "집중 횟수"

        var TimeFormat: String {
            switch self {
            case .focusCount:
                return "회"
            case .focusTime, .restTime:
                return "분"
            }
        }
    }
}
