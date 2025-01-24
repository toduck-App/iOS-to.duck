import TDDesign
import UIKit

final class TimerSettingView: BaseView {
	let recommandView = TimerRecommandView()
	let exitButton = TDBaseButton(image: TDImage.X.x1Medium, backgroundColor: .clear)
	let timerSettingTitleLabel = TDLabel(
		labelText: "타이머 설정", toduckFont: .mediumHeader4, alignment: .center,
		toduckColor: TDColor.Neutral.neutral800)

	let focusTimeField = TimerSettingField(state: .focusTime)
	let restTimeField = TimerSettingField(state: .restTime)
	let focusCountField = TimerSettingField(state: .focusCount)

	let fieldStack = UIStackView().then {
		$0.spacing = 28
		$0.axis = .vertical
		$0.distribution = .equalSpacing
		$0.alignment = .fill
	}

	let saveButton = TDButton(title: "저장", size: .large)

	override func addview() {
		addSubview(exitButton)
		addSubview(timerSettingTitleLabel)
		addSubview(recommandView)

		[focusTimeField, focusCountField, restTimeField].forEach {
			fieldStack.addArrangedSubview($0)
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

		[focusTimeField, focusCountField, restTimeField].forEach { field in
			field.snp.makeConstraints { make in
				make.height.equalTo(24)
			}
		}
	}

}

enum TimerSettingFieldState {
	case focusTime
	case restTime
	case focusCount

	var title: String {
		switch self {
		case .focusTime:
			return "집중 시간"
		case .restTime:
			return "휴식 시간"
		case .focusCount:
			return "집중 횟수"
		}
	}

	var TimeFormat: String {
		switch self {
		case .focusCount:
			return "회"
		case .focusTime, .restTime:
			return "분"

		}
	}
}

//MARK: - TimerSettingField

final class TimerSettingField: BaseView {
	let outputLabel = TDLabel(toduckFont: .mediumBody2)

	let leftButton = TDBaseButton(
		image: TDImage.Direction.leftMedium,
		backgroundColor: .clear,
		foregroundColor: TDColor.Neutral.neutral600
	).then {
		$0.layer.borderColor = UIColor.clear.cgColor
		$0.tintColor = TDColor.Neutral.neutral600

		$0.configurationUpdateHandler = { button in
			if button.state == .disabled {
				button.configuration?.baseBackgroundColor = .clear
				button.tintColor = TDColor.Neutral.neutral300
			}
		}

	}

	let rightButton = TDBaseButton(
		image: TDImage.Direction.rightMedium,
		backgroundColor: .clear,
		foregroundColor: TDColor.Neutral.neutral600
	).then {
		$0.layer.borderColor = UIColor.clear.cgColor
		$0.tintColor = TDColor.Neutral.neutral600

		$0.configurationUpdateHandler = { button in
			if button.state == .disabled {
				button.backgroundColor = .clear
				button.tintColor = TDColor.Neutral.neutral300
			} else {
				button.backgroundColor = .clear
				button.tintColor = TDColor.Neutral.neutral600
			}
		}
	}

	private let titleLabel = TDLabel(toduckFont: .mediumBody2)
	private let stack = UIStackView().then {
		$0.axis = .horizontal
		$0.spacing = 8
	}

	private let state: TimerSettingFieldState
	init(state: TimerSettingFieldState) {
		self.state = state
		super.init(frame: .zero)
	}

	override func configure() {
		titleLabel.text = state.title
		titleLabel.textAlignment = .center
		outputLabel.textAlignment = .center

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func addview() {
		addSubview(titleLabel)
		addSubview(stack)
		stack.addArrangedSubview(leftButton)
		stack.addArrangedSubview(outputLabel)
		stack.addArrangedSubview(rightButton)
	}

	override func layout() {
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.centerY.equalToSuperview()
		}

		[leftButton, rightButton].forEach { button in
			button.snp.makeConstraints { make in
				make.height.equalTo(24)
			}
		}

		outputLabel.snp.makeConstraints { make in
			make.width.equalTo(82)
		}

		stack.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.trailing.equalToSuperview()
		}

	}
}

final class TimerRecommandView: BaseView {
	private let fireImageView = UIImageView().then {
		$0.image = TDImage.fireSmall
	}
	private let titleLabel = TDLabel(labelText: "토덕의 추천 설정", toduckFont: .boldBody2)

	private let recommandStack = UIStackView().then {
		$0.spacing = 4
		$0.axis = .horizontal
		$0.distribution = .fillProportionally
		$0.alignment = .center
	}

	override func addview() {
		addSubview(fireImageView)
		addSubview(titleLabel)
		addSubview(recommandStack)
	}

	override func configure() {
		backgroundColor = TDColor.Neutral.neutral50
		layer.cornerRadius = 10
		layer.borderWidth = 1
		layer.borderColor = TDColor.Neutral.neutral300.cgColor

		[
			TDBadge(
				badgeTitle: "집중 횟수 4회", backgroundColor: TDColor.Neutral.neutral200,
				foregroundColor: TDColor.Neutral.neutral600),
			TDBadge(
				badgeTitle: "집중 시간 25분",
				backgroundColor: TDColor.Neutral.neutral200,
				foregroundColor: TDColor.Neutral.neutral600),
			TDBadge(
				badgeTitle: "휴식 시간 5분", backgroundColor: TDColor.Neutral.neutral200,
				foregroundColor: TDColor.Neutral.neutral600),
		].forEach { badge in
			recommandStack.addArrangedSubview(badge)
		}
	}

	override func layout() {
		fireImageView.snp.makeConstraints { make in
			//make.width.height.equalTo(24)
			make.leading.equalToSuperview().offset(10)
			make.top.equalToSuperview().offset(16)
		}

		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(fireImageView.snp.trailing).offset(4)
			make.top.equalTo(fireImageView.snp.top)
			make.bottom.equalTo(fireImageView.snp.bottom)

		}

		recommandStack.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(6)
			make.leading.equalTo(titleLabel.snp.leading)
		}

	}
}
