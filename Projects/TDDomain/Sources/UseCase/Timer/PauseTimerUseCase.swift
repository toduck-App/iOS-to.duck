import Foundation
import TDCore

public protocol PauseTimerUseCase {
    func start()
    func stop()
    func reset()
    var isRunning: Bool { get }
    var delegate: PauseTimerUseCaseDelegate? { get set }
    var pauseTime: Int { get }
}

public protocol PauseTimerUseCaseDelegate: AnyObject {
    func didUpdatePauseTime(remainTime: Int)
    func didFinishPauseTimer()
}

final class PauseTimerUseCaseImpl: PauseTimerUseCase {
    // MARK: - Properties

    private var timer: Timer?
    private var duration: Int = 0
    private var remainTime: Int = 0
    public var isRunning: Bool {
        return timer != nil
    }
    
    weak var delegate: PauseTimerUseCaseDelegate?
    let pauseTime = 10

    // MARK: - Initializer

    func start() {
        guard !isRunning else { return}
        self.remainTime = 10

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainTime > 0 {
                self.remainTime -= 1 //TODO: 자연스러운 프로그래스 감소를 위해 시간 뻥튀기 필요 
                self.delegate?.didUpdatePauseTime(remainTime: self.remainTime)
            } else {
                self.stop()
                self.delegate?.didFinishPauseTimer()
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

}
