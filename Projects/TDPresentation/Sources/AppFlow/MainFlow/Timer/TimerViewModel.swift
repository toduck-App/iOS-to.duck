import Combine
import Foundation
import TDCore
import TDDesign
import TDDomain
import Then

// TODO: 실행 도중 타이머 설정 변경시 처리

public final class TimerViewModel: BaseViewModel {
    enum Input {
        case fetchFocusAllSetting
        case fetchTimerSetting
        case fetchTimerTheme
        case updateTimerSetting(setting: TDTimerSetting)
        case updateTimerTheme(theme: TDTimerTheme)
        
        case didTapStartTimerButton
        case didTapResetTimerButton
        case didTapStopTimerButton
        case didTapPauseTimerButton
    }
    
    enum Output {
        case updateTime(_ remainedTime: Int)
        case updatedTimerRunning(_ isRunning: Bool?)
        case updatedTimerTheme(theme: TDTimerTheme)
        case finishedTimerOneCycle
        case fetchedFocusCount(count: Int)
        case fetchedTimerSetting(setting: TDTimerSetting)
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
    
    // MARK: - Properties
    
    private(set) var timerSetting: TDTimerSetting?
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var currentDay = Date()
    private var focusCount: Int = 0
    private var focusLimit: Int = 0
    private var startTime: Date?
    private var endTime: Date?
    private var restTime: Int = 0
    private var restCount: Int = 0
    
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
    ) {
        self.saveFocusUseCase = saveFocusUseCase
        self.focusTimerUseCase = focusTimerUseCase
        self.restTimerUseCase = restTimerUseCase
        self.pauseTimerUseCase = pauseTimerUseCase
        self.fetchTimerSettingUseCase = fetchTimerSettingUseCase
        self.updateTimerSettingUseCase = updateTimerSettingUseCase
        self.fetchTimerThemeUseCase = fetchTimerThemeUseCase
        self.updateTimerThemeUseCase = updateTimerThemeUseCase
        
        self.focusTimerUseCase.delegate = self
        self.restTimerUseCase.delegate = self
        self.pauseTimerUseCase.delegate = self
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchFocusAllSetting:
                self?.fetchTimerTheme()
                self?.fetchTimerSetting()
                self?.fetchTimerInitialStatus()
            case .fetchTimerSetting:
                self?.fetchTimerSetting()
            case let .updateTimerSetting(setting):
                self?.updateTimerSetting(setting: setting)
            case .fetchTimerTheme:
                self?.fetchTimerTheme()
                
            case .didTapStartTimerButton:
                self?.startTimer()
            case .didTapPauseTimerButton:
                self?.pauseTimer()
            case .didTapStopTimerButton:
                Task { await self?.stopTimer(isSuccess: false) }
            case .didTapResetTimerButton:
                self?.focusTimerUseCase.reset()
                
            case let .updateTimerTheme(theme):
                self?.updateTimerTheme(theme: theme)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchTimerSetting() {
        timerSetting = fetchTimerSettingUseCase.execute()
        if let timerSetting {
            output.send(.fetchedTimerSetting(setting: timerSetting))
        }
    }
    
    private func updateTimerSetting(setting: TDTimerSetting) {
        do {
            try updateTimerSettingUseCase.execute(setting: setting)
            timerSetting = fetchTimerSettingUseCase.execute()
            fetchTimerSetting()
            output.send(.updateTime(setting.toFocusDurationMinutes()))
        } catch {
            output.send(.failure("집중 설정을 실패했습니다."))
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
        startTime = Date()
        focusLimit = fetchTimerSettingUseCase.execute().focusCountLimit
        
        focusTimerUseCase.start()
        pauseTimerUseCase.reset()
        restTimerUseCase.reset()
    }
    
    /// 일시적으로 타이머를 멈춤
    private func pauseTimer() {
        focusTimerUseCase.stop()
        pauseTimerUseCase.start()
    }
    
    /// 집중 타이머를 중지하고 진행상황을 보고
    private func stopTimer(isSuccess: Bool) async {
        endTime = Date()
        focusTimerUseCase.reset()
        restTimerUseCase.reset()

        let actualStartTime = startTime ?? Date()
        let rawFocusDuration = Int(endTime?.timeIntervalSince(actualStartTime) ?? 0)

        let adjustedFocusDuration = max(0, rawFocusDuration - restTime)

        do {
            TDLogger.info("집중 타이머 종료: currentFocusCount \(focusCount), focusLimit \(focusLimit), 총 시간 \(rawFocusDuration)초, 휴식시간: \(restTime)초, 조정된 시간 \(adjustedFocusDuration)초")
            try await saveFocusUseCase.execute(
                date: currentDay.convertToString(formatType: .yearMonthDay),
                targetCount: focusCount,
                settingCount: focusLimit,
                time: adjustedFocusDuration
            )
            focusCount = 0
            restTime = 0
            restCount = 0
            output.send(.successFinishedTimer)
        } catch {
            output.send(.failure("집중 정상 종료를 실패했습니다."))
        }
    }
    
    private func fetchTimerInitialStatus() {
        output.send(.updatedTimerRunning(nil))
        output.send(.updateTime(timerSetting!.toFocusDurationMinutes()))
    }
    
    private func increaseFocusCount() {
        focusCount += 1
        
        if focusCount % timerSetting!.focusCountLimit == 0 {
            output.send(.updatedFocusCount(count: timerSetting!.focusCountLimit))
        } else {
            output.send(.updatedFocusCount(count: focusCount % timerSetting!.focusCountLimit))
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
}

// MARK: - TimerUseCaseDelegate

extension TimerViewModel: FocusTimerUseCaseDelegate {
    public func didStartFocusTimer() {
        output.send(.updatedTimerRunning(true))
        output.send(.updateTime(timerSetting!.toFocusDurationMinutes()))
    }
    
    public func didUpdateFocusTime(remainTime: Int) {
        output.send(.updatedTimerRunning(focusTimerUseCase.isRunning))
        output.send(.updateTime(remainTime))
    }
    
    public func didFinishFocusTimerOneCycle() {
        output.send(.updateTime(0))
        output.send(.finishedTimerOneCycle)
        increaseFocusCount()
        
        if focusCount % focusLimit == 0 {
            Task { await stopTimer(isSuccess: true) }
            restTimerUseCase.stop()
            output.send(.finishedFocusTimer)
        } else {
            restTimerUseCase.start()
            output.send(.updatedTimerRunning(false))
        }
    }
}

// MARK: - PauseTimerUseCaseDelegate

extension TimerViewModel: PauseTimerUseCaseDelegate {
    public func didUpdatePauseTime(remainTime: Int) {
        TDLogger.debug("현재 휴식 남은 시간: \(remainTime)")
        if remainTime == 0 {
            Task { await stopTimer(isSuccess: false) }
        }
    }
    
    public func didFinishPauseTimer() {
        focusTimerUseCase.reset()
    }
}


// MARK: - RestTimerUseCaseDelegate

extension TimerViewModel: RestTimerUseCaseDelegate {
    public func didStartRestTimer() {
        
    }
    
    public func didUpdateRestTime(remainTime: Int) {
        output.send(.updateTime(remainTime))
        restTime += 1
    }
    
    public func didFinishRestTimer() {
        focusTimerUseCase.start()
        output.send(.finishedRestTimer)
        restCount += 1
    }
}
