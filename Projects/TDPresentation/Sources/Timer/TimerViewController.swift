import Combine
import FittedSheets
import TDCore
import TDDesign
import TDDomain
import UIKit

final class TimerViewController: BaseViewController<TimerView>, TDToastPresentable {
	weak var coordinator: TimerCoordinator?
	private let viewModel: TimerViewModel!
	private let input = PassthroughSubject<TimerViewModel.Input, Never>()
	private let imageStep = 5

	private var cancellables = Set<AnyCancellable>()
	private var theme: TDTimerTheme?

	//MARK: - Initializer
	init(viewModel: TimerViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	required init?(coder: NSCoder) {
		self.viewModel = nil
		super.init(coder: coder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		input.send(.fetchTimerSetting)
		input.send(.fetchTimerInitialStatus)
	}

	override func configure() {
		//navigation bar 여기다 넣기
		setupNavigation()
		//timer buttons
		layoutView.playButton.addAction(
			UIAction { _ in
				self.input.send(.startTimer)
			}, for: .touchUpInside)

		layoutView.pauseButton.addAction(
			UIAction { _ in
				self.input.send(.stopTimer)
			}, for: .touchUpInside)

		layoutView.resetButton.addAction(
			UIAction { _ in
				self.input.send(.resetTimer)
			}, for: .touchUpInside)

		layoutView.restartButton.addAction(
			UIAction { _ in
				self.input.send(.restartTimer)
			}, for: .touchUpInside)

	}

	override func binding() {
		let output = viewModel.transform(input: input.eraseToAnyPublisher())

		output.sink { [weak self] event in
			DispatchQueue.main.async {
				switch event {
				case .updateTimer(let remainedTime):
					self?.updateImage(remainedTime: remainedTime)
					self?.updateTimerLabel(remainedTime: remainedTime)
				case .requestToast(let type, let title, let message):
					self?.showToast(type: type, title: title, message: message)
				case .receiveTimerRunningStatus(let isRunning):
					//초기 로드시 00분으로 표시 ?? 나중에 다시 바꿔야할듯;;
					guard let isRunning = isRunning else {
						self?.handleControlStack(.initilize)
						return
					}
					if isRunning {
						self?.handleControlStack(.playing)
					} else {
						self?.handleControlStack(.pause)
					}
				case .finishTimer:
					self?.handleControlStack(.pause)
					self?.layoutView.focusCountStackView.count += 1
				}
			}
		}.store(in: &cancellables)
	}

    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: TDImage.Calendar.top2Medium)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: TDImage.Dot.verticalMedium,
            primaryAction: UIAction { _ in
                let timerSettingViewController = TimerSettingViewController(
                    viewModel: self.viewModel)

                let sheetController = SheetViewController(
                    controller: timerSettingViewController, sizes: [.intrinsic],
                    options: SheetOptions(
                        shrinkPresentingViewController: false
                    ))
                sheetController.cornerCurve = .circular
                sheetController.gripSize = .zero
                sheetController.allowPullingPastMaxHeight = false
                self.present(sheetController, animated: true, completion: nil)
            })

        navigationItem.leftBarButtonItem?.tintColor = TDColor.Primary.primary300
        navigationItem.rightBarButtonItem?.tintColor = TDColor.Primary.primary300
    }

    
	//MARK: - private methods

	private func handleControlStack(_ state: TimerControlStackState) {
		let initStack = [layoutView.playButton]
		let playingStack = [
			layoutView.restartButton, layoutView.pauseButton, layoutView.resetButton,
		]
		let pauseStack = [
			layoutView.restartButton, layoutView.playButton, layoutView.resetButton,
		]

		layoutView.controlStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

		switch state {
		case .initilize:
			initStack.forEach { layoutView.controlStack.addArrangedSubview($0) }
		case .playing:
			playingStack.forEach { layoutView.controlStack.addArrangedSubview($0) }
		case .pause:
			pauseStack.forEach { layoutView.controlStack.addArrangedSubview($0) }
		}
		layoutView.layoutIfNeeded()
	}
	private func updateImage(remainedTime: Int) {
		guard let setting = self.viewModel.timerSetting else { return }
		let focusTime = setting.focusDuration

		let dividedTime: Int = focusTime / imageStep
		let index: Int = (focusTime - remainedTime) / dividedTime
		_ =
			["focus_01", "focus_02", "focus_03", "focus_04", "focus_05"][
				index < imageStep ? index : imageStep - 1]
		TDLogger.debug("image index: \(index)")
	}

	private func updateTimerLabel(remainedTime: Int) {
		let second = remainedTime % 60
		let minute = (remainedTime / 60) % 60
		let hour = minute / 60
		if hour >= 1 {
			self.layoutView.remainedFocusTimeLabel.text = String(
				format: "%d:%02d:%02d", hour, minute, second
			)
		} else {
			self.layoutView.remainedFocusTimeLabel.text = String(
				format: "%02d:%02d", minute, second)
		}
	}

	//TODO: 나중에 고치기
	private func updateTheme(_ theme: TDTimerTheme) {

	}
}

enum TimerControlStackState {
	case initilize
	case playing
	case pause
}
