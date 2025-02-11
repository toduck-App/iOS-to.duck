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
        case updatedTimerTheme(theme: TDTimerTheme)
        case updatedTimerSetting
        case finishedTimer
        case fetchedFocusCount(count: Int)
        case fetchedTimerSetting
        case updatedFocusCount(count: Int)
        case updatedMaxFocusCount(maxCount: Int)
        case failure(_ code: TimerViewModelError)
    }

    // MARK: - UseCase

    private let timerUseCase: TimerUseCase
    private let fetchTimerSettingUseCase: FetchTimerSettingUseCase
    private let updateTimerSettingUseCase: UpdateTimerSettingUseCase
    private let fetchFocusCountUseCase: FetchFocusCountUseCase
    private let updateFocusCountUseCase: UpdateFocusCountUseCase
    private let resetFocusCountUseCase: ResetFocusCountUseCase

    // MARK: - Properties

    private(set) var timerSetting: TDTimerSetting?
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - initializers

    init(
        timerUseCase: TimerUseCase,
        fetchTimerSettingUseCase: FetchTimerSettingUseCase,
        updateTimerSettingUseCase: UpdateTimerSettingUseCase,
        fetchFocusCountUseCase: FetchFocusCountUseCase,
        updateFocusCountUseCase: UpdateFocusCountUseCase,
        resetFocusCountUseCase: ResetFocusCountUseCase
    ) {
        self.timerUseCase = timerUseCase
        self.fetchTimerSettingUseCase = fetchTimerSettingUseCase
        self.updateTimerSettingUseCase = updateTimerSettingUseCase
        self.fetchFocusCountUseCase = fetchFocusCountUseCase
        self.updateFocusCountUseCase = updateFocusCountUseCase
        self.resetFocusCountUseCase = resetFocusCountUseCase
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
                self?.increaseFocusCount()
            case .increaseMaxFocusCount:
                self?.increaseMaxFocusCount()
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
    private func fetchTimerSetting() {
        timerSetting = fetchTimerSettingUseCase.execute()
        output.send(.fetchedTimerSetting)
    }

    private func updateTimerSetting(setting: TDTimerSetting) {
        timerSetting = setting
        let result = updateTimerSettingUseCase.execute(setting: setting)
        switch result {
            case let .failure(error):
                if error == .updateEntityFailure {
                    output.send(.failure(.outOfRange))
                }
                output.send(.failure(.updateFailed))
            case .success():
                output.send(.updatedTimerSetting)
                output.send(.updatedTimer(remainedTime: setting.toFocusDurationMinutes()))
        }
    }

    private func fetchTimerTheme() {}

    private func updateTimerTheme(theme _: TDTimerTheme) {}

    // TODO: 코드가 딱 봐도 불안불안함 리팩터링 필요
    private func startTimer() {
        guard let setting = timerSetting else { return }
        timerUseCase.start(setting: setting) { remainedTime in
            if remainedTime > 0 {
                self.output.send(.updatedTimer(remainedTime: remainedTime))
                self.output.send(
                    .updatedTimerRunning(
                        isRunning: self.timerUseCase.runningStatus()))
            } else { // 타이머 종료시
                self.output.send(.updatedTimer(remainedTime: 0))
                self.output.send(.finishedTimer)
            }
        }
        output.send(
            .updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    private func stopTimer() {
        timerUseCase.stop()
        output.send(
            .updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    private func resetTimer() {
        guard let setting = timerSetting else { return }
        timerUseCase.reset()
        output.send(.updatedTimer(remainedTime: setting.focusDuration))
        output.send(.updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    private func restartTimer() {
        guard let setting = timerSetting else { return }
        timerUseCase.reset()
        timerUseCase.start(setting: setting) { remainedTime in
            self.output.send(.updatedTimer(remainedTime: remainedTime))
        }
        output.send(
            .updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    private func fetchTimerRunningStatus() {
        output.send(.updatedTimerRunning(isRunning: timerUseCase.runningStatus()))
    }

    private func fetchTimerInitialStatus() {
        output.send(.updatedTimerRunning(isRunning: nil))
        output.send(.updatedTimer(remainedTime: timerSetting?.toFocusDurationMinutes() ?? 30))
    }

    private func increaseFocusCount() {
        var count = fetchFocusCountUseCase.execute()
        count += 1
        
        let result = updateFocusCountUseCase.execute(count)

        switch result {
        case let .failure(error):
            if error == .updateEntityFailure {
                output.send(.failure(.outOfRange))
            }
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedFocusCount(count: count))
        }
    }

    private func increaseMaxFocusCount() {
        guard var setting = timerSetting else { return }

        let current: Int = setting.maxFocusCount + 1
        setting.maxFocusCount = current

        let result = updateTimerSettingUseCase.execute(setting: setting)
        switch result {
        case let .failure(error):
            if error == .updateEntityFailure {
                output.send(.failure(.outOfRange))
            }
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedMaxFocusCount(maxCount: setting.maxFocusCount))
        }
    }

    private func decreaseMaxFocusCount() {
        guard var setting: TDTimerSetting = timerSetting else { return }

        let current: Int = setting.maxFocusCount - 1
        setting.maxFocusCount = current

        let result = updateTimerSettingUseCase.execute(setting: setting)
        switch result {
        case let .failure(error):
            if error == .updateEntityFailure {
                output.send(.failure(.outOfRange))
            }
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedMaxFocusCount(maxCount: setting.maxFocusCount))
        }
    }

    private func resetFocusCount() {
        let result = resetFocusCountUseCase.execute()
        switch result {
        case .failure:
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedFocusCount(count: .zero))
        }
    }

    private func fetchFocusCount() {
        let count = fetchFocusCountUseCase.execute()
        output.send(.fetchedFocusCount(count: count))
    }
}

extension TimerViewModel {
    // 흠....
    enum TimerViewModelError: Error {
        case outOfRange
        case updateFailed
    }
}
