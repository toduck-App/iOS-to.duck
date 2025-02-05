import Combine
import TDCore
import TDDesign
import TDDomain
import Then

// TODO: 실행 도중 타이머 설정 변경시 처리

public final class TimerViewModel: BaseViewModel {
    enum Input {
        case fetchTimerSetting
        case updateTimerSetting(setting: TDTimerSetting)
        case fetchTimerTheme
        case updateTimerTheme(theme: TDTimerTheme)
        case fetchTimerRunningStatus
        case fetchTimerInitialStatus
        case fetchFocusCount
        case startTimer
        case resetTimer
        case stopTimer
        case resumeTimer
        case restartTimer
        case increaseFocusCount
        case increaseMaxFocusCount
        case decreaseMaxFocusCount
        case resetFocusCount
    }

    enum Output {
        case updatedTimer(remainedTime: Int)
        case updatedTimerRunning(isRunning: Bool?)
        case finishedTimer
        case increasedFocusCount
        case increasedMaxFocusCount
        case decreasedMaxFocusCount
        case fetchedFocusCount
        case resetedFocusCount
    }

    // MARK: - UseCase

    private let timerUseCase: TimerUseCase
    private let fetchTimerSettingUseCase: FetchTimerSettingUseCase
    private let updateTimerSettingUseCase: UpdateTimerSettingUseCase
    private let fetchFocusCountUseCase: FetchFocusCountUseCase
    private let updateFocusCountUseCase: UpdateFocusCountUseCase

    // MARK: - Properties

    private(set) var timerSetting: TDTimerSetting?
    private(set) var focusCount: Int = 0
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - initializers

    init(
        timerUseCase: TimerUseCase,
        fetchTimerSettingUseCase: FetchTimerSettingUseCase,
        updateTimerSettingUseCase: UpdateTimerSettingUseCase,
        fetchFocusCountUseCase: FetchFocusCountUseCase,
        updateFocusCountUseCase: UpdateFocusCountUseCase
    ) {
        self.timerUseCase = timerUseCase
        self.fetchTimerSettingUseCase = fetchTimerSettingUseCase
        self.updateTimerSettingUseCase = updateTimerSettingUseCase
        self.fetchFocusCountUseCase = fetchFocusCountUseCase
        self.updateFocusCountUseCase = updateFocusCountUseCase
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            TDLogger.debug("[TimerViewModel] event: \(event)")
            switch event {
            case .fetchTimerSetting:
                self?.fetchTimerSetting()
            case let .updateTimerSetting(setting):
                self?.updateTimerSetting(setting: setting)
            case .fetchTimerTheme:
                self?.fetchTimerTheme()
            case let .updateTimerTheme(theme):
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
            case .fetchFocusCount:
                self?.fetchFocusCount()
            case .increaseFocusCount:
                self?.increasFocusCount()
            case .increaseMaxFocusCount:
                self?.increasMaxFocusCount()
            case .decreaseMaxFocusCount:
                self?.decreaseMaxFocusCount()
            case .resetFocusCount:
                self?.resetFocusCount()
            }
        }.store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }
}

extension TimerViewModel {
    func fetchTimerSetting() {
        timerSetting = fetchTimerSettingUseCase.execute()
    }

    func updateTimerSetting(setting: TDTimerSetting) {
        timerSetting = setting
        updateTimerSettingUseCase.execute(setting: timerSetting!)

        output.send(
            .updatedTimer(remainedTime: timerSetting!.focusDuration)
        )
    }

    func fetchTimerTheme() {}

    func updateTimerTheme(theme _: TDTimerTheme) {}

    // TODO: 딜레이 이유 찾기 -> 아마 스케줄러 작동후 send가 이유로 생각됨 스케줄러 작동전에 한번 보내줘야함
    // TODO: 코드가 딱 봐도 불안불안함 리팩터링 필요

    func startTimer() {
        guard let setting = timerSetting else { return }
        timerUseCase.start(setting: setting) { remainedTime in
            // 타이머 종료시
            if remainedTime > 0 {
                self.output.send(.updatedTimer(remainedTime: remainedTime))
                self.output.send(
                    .updatedTimerRunning(
                        isRunning: self.timerUseCase.runningStatus()))
            } else {
                self.output.send(.updatedTimer(remainedTime: 0))
                self.output.send(.finishedTimer)
            }
        }
        output.send(
            .updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    func stopTimer() {
        timerUseCase.stop()
        output.send(
            .updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    func resetTimer() {
        guard let setting = timerSetting else { return }
        timerUseCase.reset()
        output.send(.updatedTimer(remainedTime: setting.focusDuration))
        output.send(.updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    func restartTimer() {
        guard let setting = timerSetting else { return }
        timerUseCase.reset()
        timerUseCase.start(setting: setting) { remainedTime in
            self.output.send(.updatedTimer(remainedTime: remainedTime))
        }
        output.send(
            .updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    func fetchTimerRunningStatus() {
        output.send(.updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    func fetchTimerInitialStatus() {
        output.send(.updatedTimerRunning(isRunning: nil))
        output.send(.updatedTimer(remainedTime: timerSetting?.focusDuration ?? 30))
    }

    func increasFocusCount() {
        guard let setting = timerSetting else { return }

        let max: Int = setting.focusCount

        guard focusCount + 1 <= max else { return }
        focusCount += 1

        updateFocusCountUseCase.execute(focusCount)
        output.send(.increasedFocusCount)
    }

    func increasMaxFocusCount() {
        guard var setting = timerSetting else { return }

        let max = 5
        var current: Int = setting.focusCount

        if setting.focusCount + 1 <= max {
            current += 1
            setting.focusCount = current
        }

        updateTimerSettingUseCase.execute(setting: setting)
        output.send(.increasedMaxFocusCount)
    }

    func decreaseMaxFocusCount() {
        guard var setting = timerSetting else { return }

        let min = 1
        var current: Int = setting.focusCount
        if setting.focusCount - 1 >= min {
            current -= 1
            setting.focusCount = current
        }

        updateTimerSettingUseCase.execute(setting: setting)
        output.send(.decreasedMaxFocusCount)
    }

    func resetFocusCount() {
        updateFocusCountUseCase.execute(0)
        output.send(.resetedFocusCount)
    }

    func fetchFocusCount() {
        focusCount = fetchFocusCountUseCase.execute()
        output.send(.fetchedFocusCount)
    }
}
