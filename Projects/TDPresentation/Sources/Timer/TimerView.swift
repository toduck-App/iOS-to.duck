import TDDesign
import UIKit

final class TimerView: BaseView {
    let remainedFocusTimeLabel = TDLabel(labelText: "00:00", toduckFont: .boldHeader1)

    let controlStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = 22
    }

    let backdropView = UIView().then {
        $0.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.58, alpha: 1.00)
    }

    let focusCountStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }

    let bboduckView = BboduckTimerView()
    let simpleView = SimpleTimerView()

    // Buttons

    let playButton = TDBaseButton(
        image: TDImage.Timer.play,
        backgroundColor: TDColor.Primary.primary200,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let resetButton = TDBaseButton(
        image: TDImage.Timer.stop,
        backgroundColor: .clear,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let pauseButton = TDBaseButton(
        image: TDImage.Timer.pause,
        backgroundColor: TDColor.Primary.primary200,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let restartButton = TDBaseButton(
        image: TDImage.Timer.reset,
        backgroundColor: .clear,
        foregroundColor: TDColor.Neutral.neutral400
    )

    override func addview() {
        addSubview(remainedFocusTimeLabel)
        addSubview(backdropView)
        addSubview(focusCountStackView)

        controlStack.addArrangedSubview(playButton)
        addSubview(controlStack)

        addSubview(simpleView)
        addSubview(bboduckView)
    }

    override func configure() {
        simpleView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        simpleView.isHidden = true
        backgroundColor = TDColor.Primary.primary100
    }

    override func layout() {
        for button in [playButton, resetButton, pauseButton, resetButton] {
            button.snp.makeConstraints {
                $0.size.equalTo(72)
            }
        }

        // TODO: layout 다시 잡기, 숫자의 크기에 따라 전체적으로 움직임
        remainedFocusTimeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(36)
            $0.centerX.equalToSuperview()
        }

        focusCountStackView.snp.makeConstraints {
            $0.top.equalTo(remainedFocusTimeLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        simpleView.snp.makeConstraints { make in
            make.bottom.equalTo(controlStack.snp.top).inset(-44)
            make.height.equalTo(simpleView.snp.width)
            make.leading.trailing.equalToSuperview().inset(40)
        }

        controlStack.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(55)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(72)
        }

        // 임시 뷰
        backdropView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
            $0.bottom.equalToSuperview()
        }
    }
}
