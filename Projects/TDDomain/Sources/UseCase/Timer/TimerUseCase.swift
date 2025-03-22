import Foundation
import TDCore

public protocol TimerUseCase {
    func start()
    func stop()
    func reset()
    var isRunning: Bool { get }
    var delegate: TimerUseCaseDelegate? { get set }
}

public protocol TimerUseCaseDelegate: AnyObject {
    func didUpdateFocusTime(remainTime: Int)
    func didUpdateRestTime(restTime: Int)
}

final class TimerUseCaseImpl: TimerUseCase {
    // MARK: - Properties

    private var timer: Timer?
    private var duration: Int = 0
    private var remainTime: Int = 0
    public var isRunning: Bool {
        return timer != nil
    }
    private let repository: TimerRepository

    weak var delegate: TimerUseCaseDelegate?

    // MARK: - Initializer

    init(repository: TimerRepository) {
        self.repository = repository

    }

    func start() {
        guard !isRunning else { return}
        let setting = repository.fetchTimerSetting()
        self.remainTime = self.remainTime == 0 ? setting.toFocusDurationMinutes() : self.remainTime

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainTime > 0 {
                self.remainTime -= 1 //TODO: 자연스러운 프로그래스 감소를 위해 시간 뻥튀기 필요 
                self.delegate?.didUpdateFocusTime(remainTime: self.remainTime)
            } else {
                self.stop()
                self.delegate?.didUpdateRestTime(restTime: 0)
            }
        }
    }

    func stop() {
        guard isRunning else { return }
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stop()
        self.remainTime = 0
    }

    // MARK: - Private Methods

    private func scheduleTimer() {
    }
}
