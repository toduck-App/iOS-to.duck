import Foundation
import TDCore

public protocol RestTimerUseCase {
    func start()
    func stop()
    func reset()
    var isRunning: Bool { get }
    var delegate: RestTimerUseCaseDelegate? { get set }
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

        remainTime = remainTime == 0 ? setting.toRestDurationMinutes() : remainTime

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainTime > 0 {
                self.remainTime -= 1 //TODO: 자연스러운 프로그래스 감소를 위해 시간 뻥튀기 필요 
                self.delegate?.didUpdateRestTime(remainTime: self.remainTime)
            } else {
                self.stop()
                self.delegate?.didFinishRestTimer()
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
}
