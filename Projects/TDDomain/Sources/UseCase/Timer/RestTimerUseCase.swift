import Foundation
import TDCore

public protocol RestTimerUseCase {
    var isRunning: Bool { get }
    var delegate: RestTimerUseCaseDelegate? { get set }
    
    func start()
    func stop()
    func reset()
}

public protocol RestTimerUseCaseDelegate: AnyObject {
    func didUpdateRestTime(remainTime: Int)
    func didFinishRestTimer()
}

final class RestTimerUseCaseImpl: RestTimerUseCase {
    // MARK: - Properties

    private var timer: Timer?
    private var duration: Int = 0
    private var remainTime: Int = 0
    public var isRunning: Bool {
        return timer != nil
    }
    private let repository: FocusRepository

    weak var delegate: RestTimerUseCaseDelegate?

    // MARK: - Initializer

    init(repository: FocusRepository) {
        self.repository = repository
    }

    func start() {
        guard !isRunning else { return}
        let setting = repository.fetchTimerSetting()

        remainTime = remainTime == 0
        ? setting.toRestDurationMinutes()
        : remainTime

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if remainTime > 0 {
                remainTime -= 1
                delegate?.didUpdateRestTime(remainTime: remainTime)
            } else {
                stop()
                delegate?.didFinishRestTimer()
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
