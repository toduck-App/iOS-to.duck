import Combine
import TDCore
import TDDomain
import UIKit

final class TimerSettingViewController: BaseViewController<TimerSettingView> {

	//MARK: - Properties
	private let viewModel: TimerViewModel
	private let input = PassthroughSubject<TimerViewModel.Input, Never>()
	private var cancellables = Set<AnyCancellable>()

	private var focusTime: Int {
		didSet {
			layoutView.focusTimeField.leftButton.isEnabled = focusTime > 5
			layoutView.focusTimeField.rightButton.isEnabled = focusTime < 60
			layoutView.focusTimeField.outputLabel.text = "\(focusTime)분"
		}
	}
	private var focusCount: Int {
		didSet {
			layoutView.focusCountField.leftButton.isEnabled = focusCount > 1
			layoutView.focusCountField.rightButton.isEnabled = focusCount < 5
			layoutView.focusCountField.outputLabel.text = "\(focusCount)회"
		}
	}
	private var restTime: Int {
		didSet {
			layoutView.restTimeField.leftButton.isEnabled = restTime > 0
			layoutView.restTimeField.rightButton.isEnabled = restTime < 10
			layoutView.restTimeField.outputLabel.text = "\(restTime)분"
		}
	}

	// MARK: - initializers
	init(viewModel: TimerViewModel) {
		self.viewModel = viewModel
		self.focusTime = 25
		self.focusCount = 4
		self.restTime = 5

		super.init()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        
        input.send(.fetchTimerSetting)
		guard let setting = viewModel.timerSetting else { return }

		//Debug
		TDLogger.debug(
			"setting: \(setting.focusDuration) \(setting.foucsCount) \(setting.restDuration)"
		)
		self.focusTime = setting.focusDuration
		self.focusCount = setting.foucsCount
		self.restTime = setting.restDuration

	}

	override func configure() {
		//focus time field
		layoutView.focusTimeField.leftButton.addAction(
			UIAction { _ in
				self.focusTime -= 5
			}, for: .touchUpInside)

		layoutView.focusTimeField.rightButton.addAction(
			UIAction { _ in
				self.focusTime += 5
			}, for: .touchUpInside)

		//focus count field
		layoutView.focusCountField.leftButton.addAction(
			UIAction { _ in
				self.focusCount -= 1
			}, for: .touchUpInside)

		layoutView.focusCountField.rightButton.addAction(
			UIAction { _ in
				self.focusCount += 1
			}, for: .touchUpInside)

		//rest time field
		layoutView.restTimeField.leftButton.addAction(
			UIAction { _ in
				self.restTime -= 1
			}, for: .touchUpInside)

		layoutView.restTimeField.rightButton.addAction(
			UIAction { _ in
				self.restTime += 1
			}, for: .touchUpInside)

		//save button
		layoutView.saveButton.addAction(
			UIAction { _ in
				self.input.send(
					.updateTimerSetting(
                        setting: TDTimerSetting(
							focusDuration: self.focusTime,
							foucsCount: self.focusCount,
							restDuration: self.restTime)))
                
				self.close()
			}, for: .touchUpInside)

		layoutView.exitButton.addAction(
			UIAction { _ in
				self.close()
			}, for: .touchUpInside)
	}

	override func binding() {
		let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
		output.sink { [weak self] event in
			switch event {
			default:
                break
			}

		}.store(in: &cancellables)
	}

	//MARK: - Private Mehtods
	private func close() {
		self.dismiss(animated: true)
	}

}
