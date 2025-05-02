import Combine
import Foundation
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
        case pauseTimer
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
        case fetchedTimerSetting(setting: TDTimerSetting) // viewmodel에서 변수로 활용됨
        case fetchedTimerTheme(theme: TDTimerTheme)
        case updatedFocusCount(count: Int)
        case updatedMaxFocusCount(maxCount: Int)
        case stoppedTimer
        case startTimer
        case failure(_ message: String)
        
        case finishedFocusTimer
        case finishedRestTimer
        case successFinishedTimer
    }
    
    // MARK: - UseCase
    /// Server
    private let saveFocusUseCase: SaveFocusUseCase
    
    /// Storage
    private var focusTimerUseCase: FocusTimerUseCase
    private var restTimerUseCase: RestTimerUseCase
    private var pauseTimerUseCase: PauseTimerUseCase
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
    private var currentDay = Date()
    private var focusCount: Int = 0
    private var focusLimit: Int = 0
    private var focusDuration: Int = 0
    
    // MARK: - initializers
    
    init(
        saveFocusUseCase: SaveFocusUseCase,
        focusTimerUseCase: FocusTimerUseCase,
        restTimerUseCase: RestTimerUseCase,
        pauseTimerUseCase: PauseTimerUseCase,
        fetchTimerSettingUseCase: FetchTimerSettingUseCase,
        updateTimerSettingUseCase: UpdateTimerSettingUseCase,
        fetchTimerThemeUseCase: FetchTimerThemeUseCase,
        updateTimerThemeUseCase: UpdateTimerThemeUseCase,
        fetchFocusCountUseCase: FetchFocusCountUseCase,
        updateFocusCountUseCase: UpdateFocusCountUseCase,
        resetFocusCountUseCase: ResetFocusCountUseCase
    ) {
        self.saveFocusUseCase = saveFocusUseCase
        self.focusTimerUseCase = focusTimerUseCase
        self.restTimerUseCase = restTimerUseCase
        self.pauseTimerUseCase = pauseTimerUseCase
        self.fetchTimerSettingUseCase = fetchTimerSettingUseCase
        self.updateTimerSettingUseCase = updateTimerSettingUseCase
        self.fetchTimerThemeUseCase = fetchTimerThemeUseCase
        self.updateTimerThemeUseCase = updateTimerThemeUseCase
        self.fetchFocusCountUseCase = fetchFocusCountUseCase
        self.updateFocusCountUseCase = updateFocusCountUseCase
        self.resetFocusCountUseCase = resetFocusCountUseCase
        
        self.focusTimerUseCase.delegate = self
        self.restTimerUseCase.delegate = self
        self.pauseTimerUseCase.delegate = self
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchTimerSetting:
                self?.fetchTimerSetting()
            case let .updateTimerSetting(setting):
                self?.updateTimerSetting(setting: setting)
            case .fetchTimerTheme:
                self?.fetchTimerTheme()
            case let .updateTimerTheme(theme):
                self?.updateTimerTheme(theme: theme)
            case .startTimer:
                self?.startTimer()
            case .pauseTimer:
                self?.pauseTimer()
            case .stopTimer:
                Task { await self?.stopTimer() }
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
        guard let setting = timerSetting else { return}
        output.send(.fetchedTimerSetting(setting: setting))
    }
    
    private func updateTimerSetting(setting: TDTimerSetting) {
        do {
            try updateTimerSettingUseCase.execute(setting: setting)
            timerSetting = fetchTimerSettingUseCase.execute()
            output.send(.updatedTimerSetting)
            output.send(.updatedTimer(setting.toFocusDurationMinutes()))
        } catch {
            output.send(.failure("집중 토마토 개수 범위를 벗어났습니다."))
        }
    }
    
    private func fetchTimerTheme() {
        let theme = fetchTimerThemeUseCase.execute()
        output.send(.fetchedTimerTheme(theme: theme))
    }
    
    private func updateTimerTheme(theme: TDTimerTheme) {
        do {
            try updateTimerThemeUseCase.execute(theme: theme)
            output.send(.updatedTimerTheme(theme: theme))
        } catch {
            output.send(.failure("집중 토마토 개수 범위를 벗어났습니다."))
        }
    }
    
    // MARK: - Timer Logic
    
    private func startTimer() {
        focusTimerUseCase.start()
        
        pauseTimerUseCase.reset()
        restTimerUseCase.reset()
        output.send(.updatedTimerRunning(focusTimerUseCase.isRunning))
    }
    
    /// 일시적으로 타이머를 멈춤
    private func pauseTimer() {
        focusTimerUseCase.stop()
        
        pauseTimerUseCase.start()
        output.send(.updatedTimerRunning(focusTimerUseCase.isRunning))
    }
    
    private func resetTimer() {
        focusTimerUseCase.reset()
        output.send(.updatedTimer(timerSetting!.toFocusDurationMinutes()))
        output.send(.updatedTimerRunning(focusTimerUseCase.isRunning))
    }
    
    /// 집중 타이머를 중지하고 진행상황을 보고
    private func stopTimer() async {
        resetTimer()
        restTimerUseCase.reset()
        let count = fetchFocusCountUseCase.execute()
        do {
            try updateFocusCountUseCase.execute(0)
            resetFocusCount()
            let limit = fetchTimerSettingUseCase.execute().focusCountLimit

            try await saveFocusUseCase.execute(
                date: currentDay.convertToString(formatType: .yearMonthDay),
                targetCount: count,
                settingCount: limit,
                time: 123
            )
            output.send(.successFinishedTimer)
        } catch {
            output.send(.failure("집중 정상 종료를 실패했습니다."))
        }
    }
    
    private func fetchTimerRunningStatus() {
        output.send(.updatedTimerRunning(focusTimerUseCase.isRunning))
    }
    
    private func fetchTimerInitialStatus() {
        output.send(.updatedTimerRunning(nil))
        output.send(.updatedTimer(timerSetting!.toFocusDurationMinutes()))
    }
    
    private func increaseFocusCount() {
        do {
            var count = fetchFocusCountUseCase.execute()
            count += 1
            
            try updateFocusCountUseCase.execute(count)
            
            if count % timerSetting!.focusCountLimit == 0 {
                output.send(.updatedFocusCount(count: timerSetting!.focusCountLimit))
            } else {
                output.send(.updatedFocusCount(count: count % timerSetting!.focusCountLimit))
            }
        } catch {
            output.send(.failure("집중 토마토 개수 범위를 벗어났습니다."))
        }
    }
    
    private func increaseMaxFocusCount() {
        guard var setting = timerSetting else { return }
        
        let current = setting.focusCountLimit + 1
        setting.focusCountLimit = current
        
        do {
            try updateTimerSettingUseCase.execute(setting: setting)
            output.send(.updatedMaxFocusCount(maxCount: setting.focusCountLimit))
        } catch {
            output.send(.failure("집중 토마토 개수 범위를 벗어났습니다."))
        }
    }
    
    private func decreaseMaxFocusCount() {
        guard var setting: TDTimerSetting = timerSetting else { return }
        
        let current = setting.focusCountLimit - 1
        setting.focusCountLimit = current
        
        do {
            try updateTimerSettingUseCase.execute(setting: setting)
            output.send(.updatedMaxFocusCount(maxCount: setting.focusCountLimit))
        } catch {
            output.send(.failure("집중 토마토 개수 범위를 벗어났습니다."))
        }
    }
    
    private func resetFocusCount() {
        do {
            try resetFocusCountUseCase.execute()
            output.send(.updatedFocusCount(count: .zero))
        } catch {
            output.send(.failure("집중 정상 종료를 실패했습니다."))
        }
    }
    
    private func fetchFocusCount() {
        let count = fetchFocusCountUseCase.execute()
        output.send(.fetchedFocusCount(count: count))
    }
}

// MARK: - TimerUseCaseDelegate

extension TimerViewModel: FocusTimerUseCaseDelegate {
    public func didStartFocusTimer() {
        output.send(.updatedTimerRunning(true))
        output.send(.updatedTimer(timerSetting!.toFocusDurationMinutes()))
    }
    
    public func didUpdateFocusTime(remainTime: Int) {
        output.send(.updatedTimerRunning(focusTimerUseCase.isRunning))
        output.send(.updatedTimer(remainTime))
    }
    
    public func didFinishFocusTimer() {
        output.send(.updatedTimer(0))
        output.send(.finishedTimer)
        
        let limit = fetchTimerSettingUseCase.execute().focusCountLimit
        let count = fetchFocusCountUseCase.execute()
        
        if (count + 1) % limit == 0 {
            restTimerUseCase.stop()
            resetFocusCount()
            Task { await stopTimer() }
            output.send(.finishedFocusTimer)
        } else {
            restTimerUseCase.start()
            output.send(.updatedTimerRunning(false))
        }
    }
}

extension TimerViewModel: RestTimerUseCaseDelegate {
    public func didStartRestTimer() {
        
    }
    
    public func didUpdateRestTime(remainTime: Int) {
        output.send(.updatedTimer(remainTime))
    }
    
    public func didFinishRestTimer() {
        focusTimerUseCase.start()
        output.send(.finishedRestTimer)
    }
}

extension TimerViewModel: PauseTimerUseCaseDelegate {
    public func didUpdatePauseTime(remainTime: Int) {
        TDLogger.debug("현재 휴식 남은 시간: \(remainTime)")
    }
    
    public func didFinishPauseTimer() {
        focusTimerUseCase.reset()
    }
}
