import Foundation
import TDCore

public protocol FocusTimerUseCase {
    func start()
    func start(from remainTime: Int)
    func stop()
    func reset()
    var isRunning: Bool { get }
    var delegate: FocusTimerUseCaseDelegate? { get set }
}

public protocol FocusTimerUseCaseDelegate: AnyObject {
    func didUpdateFocusTime(remainTime: Int)
    func didFinishFocusTimerOneCycle()
    func didStartFocusTimer()
}

final class FocusTimerUseCaseImpl: FocusTimerUseCase {
    // MARK: - Properties

    private var timer: Timer?
    private var duration: Int = 0
    private var remainTime: Int = 0
    public var isRunning: Bool {
        return timer != nil
    }
    private let repository: FocusRepository

    weak var delegate: FocusTimerUseCaseDelegate?

    // MARK: - Initializer

    init(repository: FocusRepository) {
        self.repository = repository
    }

    func start() {
        guard !isRunning else { return}
        let setting = repository.fetchTimerSetting()
        remainTime = remainTime == 0
        ? setting.toFocusDurationMinutes()
        : remainTime

        if remainTime == setting.toFocusDurationMinutes() {
            delegate?.didStartFocusTimer()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if remainTime > 0 {
                remainTime -= 1 // TODO: 자연스러운 프로그래스 감소를 위해 시간 뻥튀기 필요
                delegate?.didUpdateFocusTime(remainTime: remainTime)
            } else {
                delegate?.didFinishFocusTimerOneCycle()
                stop()
            }
        }
    }
    
    func start(from remainTime: Int) {
        self.remainTime = remainTime
        start()
    }

    func stop() {
        guard isRunning else { return }
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stop()
        remainTime = 0
    }
}
