import Combine
import TDCore
import TDDesign
import TDDomain
import Then

//TODO: 실행 도중 타이머 설정 변경시 처리
//TODO:

public final class TimerViewModel: BaseViewModel {
	enum Input {
		case fetchTimerSetting
		case updateTimerSetting(setting: TDTimerSetting)
		case fetchTimerTheme
		case updateTimerTheme(theme: TDTimerTheme)
		case fetchTimerRunningStatus
		case fetchTimerInitialStatus
		case startTimer
		case resetTimer
		case stopTimer
		case resumeTimer
		case restartTimer
	}

	enum Output {
		case updateTimer(remainedTime: Int)
        case requestToast(type: TDToast.TDToastType, title: String, message: String)
		case receiveTimerRunningStatus(isRunning: Bool?)
		case finishTimer
	}

	// MARK: - UseCase
	private let timerUseCase: TimerUseCase
	private let fetchTimerSettingUseCase: FetchTimerSettingUseCase
	private let updateTimerSettingUseCase: UpdateTimerSettingUseCase

	// MARK: - Properties
	private(set) var timerSetting: TDTimerSetting?
	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - initializers
	init(
		timerUseCase: TimerUseCase,
		fetchTimerSettingUseCase: FetchTimerSettingUseCase,
		updateTimerSettingUseCase: UpdateTimerSettingUseCase
	) {
		self.timerUseCase = timerUseCase
		self.fetchTimerSettingUseCase = fetchTimerSettingUseCase
		self.updateTimerSettingUseCase = updateTimerSettingUseCase
	}

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			TDLogger.debug("TimerViewModel event: \(event)")
			switch event {
			case .fetchTimerSetting:
				self?.fetchTimerSetting()
			case .updateTimerSetting(let setting):
				self?.updateTimerSetting(setting: setting)
			case .fetchTimerTheme:
				self?.fetchTimerTheme()
			case .updateTimerTheme(let theme):
				self?.updateTimerTheme(theme: theme)
			case .startTimer, .resumeTimer:
				self?.startTimer()
			case .stopTimer:
				self?.stopTimer()
			case .resetTimer:
				self?.resetTimer()
			case .restartTimer:
				self?.restartTimer()
			case .fetchTimerRunningStatus:
				self?.fetchTimerRunningStatus()
			case .fetchTimerInitialStatus:
				self?.fetchTimerInitialStatus()
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}
}

extension TimerViewModel {
	func fetchTimerSetting() {
		Task {
			do {
				timerSetting = fetchTimerSettingUseCase.execute()
			}
		}
	}

	func updateTimerSetting(setting: TDTimerSetting) {
		Task {
			do {
				self.timerSetting = setting
				updateTimerSettingUseCase.execute(setting: self.timerSetting!)

				output.send(
					.updateTimer(remainedTime: self.timerSetting!.focusDuration)
				)
			}
		}
	}

	func fetchTimerTheme() {
		Task {
			do {

			}
		}
	}

	func updateTimerTheme(theme: TDTimerTheme) {
		Task {
			do {

			}
		}
	}

	//TODO: 딜레이 이유 찾기 -> 아마 스케줄러 작동후 send가 이유로 생각됨 스케줄러 작동전에 한번 보내줘야함
	//TODO: 코드가 딱 봐도 불안불안함 리팩터링 필요

	func startTimer() {
		guard let setting = timerSetting else { return }
		timerUseCase.start(setting: setting) { remainedTime in
			//타이머 종료시
			if remainedTime > 0 {
				self.output.send(.updateTimer(remainedTime: remainedTime))
				self.output.send(
					.receiveTimerRunningStatus(
						isRunning: self.timerUseCase.runningStatus()))
			} else {
				self.output.send(
					.requestToast(
						type: .green, title: "타이머 종료",
						message: "타이머가 종료되었습니다."))
				self.output.send(.updateTimer(remainedTime: 0))
				self.output.send(.finishTimer)
			}
		}
		self.output.send(
			.receiveTimerRunningStatus(isRunning: timerUseCase.runningStatus()))
	}

	func stopTimer() {
		timerUseCase.stop()
		self.output.send(
			.receiveTimerRunningStatus(isRunning: timerUseCase.runningStatus()))
	}

	func resetTimer() {
		guard let setting = timerSetting else { return }
		timerUseCase.reset()
		output.send(.updateTimer(remainedTime: setting.focusDuration))
		output.send(.receiveTimerRunningStatus(isRunning: timerUseCase.runningStatus()))
	}

	func restartTimer() {
		guard let setting = timerSetting else { return }
		timerUseCase.reset()
		timerUseCase.start(setting: setting) { remainedTime in
			self.output.send(.updateTimer(remainedTime: remainedTime))
		}
		self.output.send(
			.receiveTimerRunningStatus(isRunning: timerUseCase.runningStatus()))
	}

	func fetchTimerRunningStatus() {
		output.send(.receiveTimerRunningStatus(isRunning: timerUseCase.runningStatus()))
	}

	func fetchTimerInitialStatus() {
		output.send(.receiveTimerRunningStatus(isRunning: nil))
		output.send(.updateTimer(remainedTime: timerSetting?.focusDuration ?? 30))
	}
}
