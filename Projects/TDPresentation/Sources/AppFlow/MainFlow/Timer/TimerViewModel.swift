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
        case increaseFocusCount
        case increaseMaxFocusCount
        case decreaseMaxFocusCount
        case resetFocusCount
    }

    enum Output {
        case updatedTimer(_ remainedTime: Int)
        case updatedTimerRunning(_ isRunning: Bool?)
        case updatedTimerTheme(theme: TDTimerTheme)
        case updatedTimerSetting
        case finishedTimer
        case fetchedFocusCount(count: Int)
        case fetchedTimerSetting // viewmodel에서 변수로 활용됨
        case fetchedTimerTheme(theme: TDTimerTheme)
        case updatedFocusCount(count: Int)
        case updatedMaxFocusCount(maxCount: Int)
        case failure(_ code: TimerViewModelError)
        case stopedTimer
        case startTimer
    }

    // MARK: - UseCase

    private var timerUseCase: TimerUseCase
    private let fetchTimerSettingUseCase: FetchTimerSettingUseCase
    private let updateTimerSettingUseCase: UpdateTimerSettingUseCase
    private let fetchTimerThemeUseCase: FetchTimerThemeUseCase
    private let updateTimerThemeUseCase: UpdateTimerThemeUseCase
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
        fetchTimerThemeUseCase: FetchTimerThemeUseCase,
        updateTimerThemeUseCase: UpdateTimerThemeUseCase,
        fetchFocusCountUseCase: FetchFocusCountUseCase,
        updateFocusCountUseCase: UpdateFocusCountUseCase,
        resetFocusCountUseCase: ResetFocusCountUseCase
    ) {
        self.timerUseCase = timerUseCase
        self.fetchTimerSettingUseCase = fetchTimerSettingUseCase
        self.updateTimerSettingUseCase = updateTimerSettingUseCase
        self.fetchTimerThemeUseCase = fetchTimerThemeUseCase
        self.updateTimerThemeUseCase = updateTimerThemeUseCase
        self.fetchFocusCountUseCase = fetchFocusCountUseCase
        self.updateFocusCountUseCase = updateFocusCountUseCase
        self.resetFocusCountUseCase = resetFocusCountUseCase

        self.timerUseCase.delegate = self
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
            output.send(.updatedTimer(setting.toFocusDurationMinutes()))
        }
    }

    private func fetchTimerTheme() {
        let theme = fetchTimerThemeUseCase.execute()
        output.send(.fetchedTimerTheme(theme: theme))
    }

    private func updateTimerTheme(theme: TDTimerTheme) {
        let result = updateTimerThemeUseCase.execute(theme: theme)
        switch result {
        case let .failure(error):
            if error == .updateEntityFailure {
                output.send(.failure(.outOfRange))
            }
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedTimerTheme(theme: theme))
        }
    }

    private func startTimer() {
        timerUseCase.start()
        output.send(.updatedTimerRunning(timerUseCase.isRunning))
    }

    

    private func resetTimer() {
        timerUseCase.reset()
        output.send(.updatedTimer(timerSetting!.toFocusDurationMinutes()))
        output.send(.updatedTimerRunning(timerUseCase.isRunning))
    }

    private func stopTimer() {
        self.resetTimer()
        //TODO: 비지니스 로직 추가
    }

    private func fetchTimerRunningStatus() {
        output.send(.updatedTimerRunning(timerUseCase.isRunning))
    }

    private func fetchTimerInitialStatus() {
        output.send(.updatedTimerRunning(nil))
        output.send(.updatedTimer(timerSetting!.toFocusDurationMinutes()))
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

        let current: Int = setting.focusCountLimit + 1
        setting.focusCountLimit = current

        let result = updateTimerSettingUseCase.execute(setting: setting)
        switch result {
        case let .failure(error):
            if error == .updateEntityFailure {
                output.send(.failure(.outOfRange))
            }
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedMaxFocusCount(maxCount: setting.focusCountLimit))
        }
    }

    private func decreaseMaxFocusCount() {
        guard var setting: TDTimerSetting = timerSetting else { return }

        let current: Int = setting.focusCountLimit - 1
        setting.focusCountLimit = current

        let result = updateTimerSettingUseCase.execute(setting: setting)
        switch result {
        case let .failure(error):
            if error == .updateEntityFailure {
                output.send(.failure(.outOfRange))
            }
            output.send(.failure(.updateFailed))
        case .success():
            output.send(.updatedMaxFocusCount(maxCount: setting.focusCountLimit))
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

// MARK: - TimerUseCaseDelegate
extension TimerViewModel: TimerUseCaseDelegate {
    public func didUpdateFocusTime(remainTime: Int) {
        if remainTime > 0 {
            output.send(.updatedTimer(remainTime))
            output.send(.updatedTimerRunning(timerUseCase.isRunning))
        } else {
            output.send(.updatedTimer(0))
            output.send(.finishedTimer)
        }
        output.send(.updatedTimer(remainTime))
    }

    public func didUpdateRestTime(restTime: Int) {
        TDLogger.debug("[TimerViewModel] didUpdateRestTime: \(restTime)")
    }
}

extension TimerViewModel {
    enum TimerViewModelError: Error {
        case outOfRange
        case updateFailed
    }
}
