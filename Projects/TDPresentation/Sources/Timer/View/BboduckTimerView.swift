import SnapKit
import TDDesign
import TDCore
import UIKit
import Lottie

final class BboduckTimerView: BaseTimerView {
    private static let toduckBundle = Bundle(identifier: "to.duck.toduck.design")!

    private let images: [String] = [
        "toduckTimer_0",
        "toduckTimer_1",
        "toduckTimer_2",
        "toduckTimer_3",
        "toduckTimer_4",
        "toduckTimer_5",
    ]

    let bboduckView = LottieAnimationView(
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
            updateProgress()
        }
    }

    func updateProgress() {
        let clampedProgress = min(max(progress, 0), 1)
        
        let stepSize = 1.0 / CGFloat(images.count - 1)
        let imageIndex = min(Int(clampedProgress / stepSize), images.count - 1)

        let newAnimation = LottieAnimation.named(images[imageIndex], bundle: BboduckTimerView.toduckBundle)

        bboduckView.animation = newAnimation
        bboduckView.play()
    }
}
