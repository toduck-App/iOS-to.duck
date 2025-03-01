import Foundation
import TDCore

public protocol TimerUseCase {
    func start(setting: TDTimerSetting, completion: @escaping (Int) -> Void)
    func stop()
    func reset()
    func runningStatus() -> Bool
}

final class TimerUseCaseImpl: TimerUseCase {
    private var timer: Timer?
    private var setting: TDTimerSetting?
    private var duration: Int?
    private var remainTime: Int?
    private var isRunning: Bool = false

    func start(setting: TDTimerSetting, completion: @escaping (Int) -> Void) {
        if isRunning { return }

        isRunning = true
        remainTime = remainTime ?? setting.toFocusDurationMinutes()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            self?.updateRemainTime()
            completion(self?.remainTime ?? 0)
        }
    }

    func stop() {
        if !isRunning { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stop()
        remainTime = nil
    }

    func updateRemainTime() {
        guard let remainTime = remainTime else { return }
        if remainTime > 1 {
            TDLogger.debug("[TimerUseCase] remainTime: \(remainTime)")
            self.remainTime = remainTime - 1
        } else {
            reset()
            TDLogger.debug("[TimerUseCase] reset Timer")
        }
    }

    func runningStatus() -> Bool {
        return isRunning
    }
}
