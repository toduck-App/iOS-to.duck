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

    let focusCountStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }

    // Buttons

    let playButton = TDBaseButton(
        image: TDImage.Timer.play,
        backgroundColor: TDColor.Primary.primary200,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let stopButton = TDBaseButton(
        image: TDImage.Timer.stop,
        backgroundColor: .clear,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let pauseButton = TDBaseButton(
        image: TDImage.Timer.pause,
        backgroundColor: TDColor.Primary.primary200,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let resetButton = TDBaseButton(
        image: TDImage.Timer.reset,
        backgroundColor: .clear,
        foregroundColor: TDColor.Neutral.neutral400
    )

    let simpleTimerView = SimpleTimerView()
    let bboduckTimerView = BboduckTimerView()

    // MARK: - Navigation Item
    lazy var rightNavigationMenuButton = UIButton(type: .custom).then {
        let dotImageView = UIImageView(image: TDImage.Dot.verticalMedium.withRenderingMode(.alwaysTemplate)).then {
            $0.tintColor = TDColor.Primary.primary300
        }
        // addview
        $0.addSubview(dotImageView)

        // layout
        dotImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
    }

    lazy var dropDownView = TDDropdownHoverView(
        anchorView: rightNavigationMenuButton,
        layout: .trailing,
        width: 128
    )

    let leftNavigationItem = UIButton(type: .custom).then {
        let logo = UIImageView(image: TDImage.toduckLogo.withRenderingMode(.alwaysTemplate)).then {
            $0.tintColor = TDColor.Primary.primary300
        }

        let calendar = UIImageView(image: TDImage.Calendar.top2MediumOrange)

        $0.addSubview(calendar)
        $0.addSubview(logo)

        calendar.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        logo.snp.makeConstraints {
            $0.leading.equalTo(calendar.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Override Method
    override func addview() {
        addSubview(simpleTimerView)
        addSubview(bboduckTimerView)

        addSubview(remainedFocusTimeLabel)
        addSubview(focusCountStackView)

        controlStack.addArrangedSubview(playButton)
        addSubview(controlStack)

    }

    override func configure() {
        simpleTimerView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0) //y축 대칭
        backgroundColor = TDColor.Primary.primary100

        bboduckTimerView.isHidden = true
        simpleTimerView.isHidden = true
    }

    override func layout() {
        for button in [playButton, resetButton, pauseButton, resetButton] {
            button.snp.makeConstraints {
                $0.size.equalTo(72)
            }
        }

        // TODO: layout 다시 잡기, 숫자의 크기에 따라 전체적으로 움직임
        remainedFocusTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(36)
            make.height.equalTo(remainedFocusTimeLabel.font.lineHeight)
            make.centerX.equalToSuperview()
        }

        focusCountStackView.snp.makeConstraints { make in
            make.top.equalTo(remainedFocusTimeLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        controlStack.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(55)
            make.centerX.equalToSuperview()
            make.height.equalTo(72)
        }

        bboduckTimerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(remainedFocusTimeLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(200)
        }

        simpleTimerView.snp.makeConstraints { make in
            make.bottom.equalTo(controlStack.snp.top).inset(-44)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(simpleTimerView.snp.width)
        }
    }
}
