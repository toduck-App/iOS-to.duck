import Foundation
import Dispatch

public final class TDCountdownTimer {
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue.main

    private(set) var remaining: Int
    private let tick: (Int) -> Void
    private let completion: () -> Void

    public init(seconds: Int,
         tick: @escaping (Int) -> Void,
         completion: @escaping () -> Void) {
        self.remaining = seconds
        self.tick = tick
        self.completion = completion
    }
    
    deinit {
        stop()
    }

    public func start() {
        guard timer == nil else { return }

        let source = DispatchSource.makeTimerSource(queue: queue)
        source.schedule(deadline: .now() + 1, repeating: 1)

        source.setEventHandler { [weak self] in
            guard let self else { return }

            self.remaining -= 1
            self.tick(self.remaining)

            if self.remaining <= 0 {
                self.stop()
                self.completion()
            }
        }

        self.timer = source
        source.resume()
    }

    public func stop() {
        timer?.cancel()
        timer = nil
    }
}
