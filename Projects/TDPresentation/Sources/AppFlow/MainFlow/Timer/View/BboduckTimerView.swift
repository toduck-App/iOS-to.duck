import SnapKit
import TDDesign
import TDCore
import UIKit
import Lottie

final class BboduckTimerView: BaseTimerView {
    private static let toduckBundle = Bundle(identifier: "to.duck.toduck.design")!

    private let pauseImage = "Timer_0"

    private let images: [String] = [
        "Timer_1",
        "Timer_2",
        "Timer_3",
        "Timer_4",
        "Timer_5",
    ]

    private let bboduckView = LottieAnimationView(
        name: "bboduckTimer",
        bundle: BboduckTimerView.toduckBundle
    ).then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
    }


    override func addview() {
        addSubview(bboduckView)
    }

    override func layout() {
        bboduckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override var progress: CGFloat {
        didSet {
            guard isRunning else { return }
            updateProgress()
        }
    }

    private func updateProgress() {
        let clampedProgress = min(max(progress, 0), 1)
        
        let stepSize = 1.0 / CGFloat(images.count - 1)
        let imageIndex = min(Int(clampedProgress / stepSize), images.count - 1)

        TDLogger.debug("[BboduckTimerView#updateProgress] progress: \(progress), imageIndex: \(imageIndex)")

        let newAnimation = LottieAnimation.named(images[imageIndex], bundle: BboduckTimerView.toduckBundle)

        bboduckView.animation = newAnimation
        bboduckView.play()
    }

    public func pause() {
        let pauseAnimation = LottieAnimation.named(pauseImage, bundle: BboduckTimerView.toduckBundle)
        bboduckView.animation = pauseAnimation
        bboduckView.play() // 요청마다 처음부터 재생됨 방지 필요
    }
}
