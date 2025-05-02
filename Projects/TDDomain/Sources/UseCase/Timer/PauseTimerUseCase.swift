import Foundation
import TDCore

public protocol PauseTimerUseCase {
    var isRunning: Bool { get }
    var delegate: PauseTimerUseCaseDelegate? { get set }
    var pauseTime: Int { get }
    
    func start()
    func stop()
    func reset()
}

public protocol PauseTimerUseCaseDelegate: AnyObject {
    func didUpdatePauseTime(remainTime: Int)
    func didFinishPauseTimer()
}

final class PauseTimerUseCaseImpl: PauseTimerUseCase {
    // MARK: - Properties

    private var timer: Timer?
    private var duration: Int = 0
    private(set) var pauseTime = 20
    private(set) var remainTime: Int = 0
    
    public var isRunning: Bool {
        return timer != nil
    }
    
    weak var delegate: PauseTimerUseCaseDelegate?

    // MARK: - Initializer

    func start() {
        guard !isRunning else { return}
        self.remainTime = 20

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if remainTime > 0 {
                remainTime -= 1 //TODO: 자연스러운 프로그래스 감소를 위해 시간 뻥튀기 필요
                delegate?.didUpdatePauseTime(remainTime: remainTime)
            } else {
                stop()
                delegate?.didFinishPauseTimer()
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
        remainTime = 0
    }
}
