import SnapKit
import TDDesign
import TDCore
import UIKit
import Lottie

final class BboduckTimerView: BaseTimerView {
    private static let toduckBundle = Bundle(identifier: "to.duck.toduck.design")!

    private let pauseImage = "Timer_0"
    private var preLottieIndex = -1
    private let images: [String] = [
        "Timer_1",
        "Timer_2",
        "Timer_3",
        "Timer_4",
        "Timer_5",
    ]

    private var currentFrame: CGFloat = 0 // 현재 재생 중인 애니메이션의 프레임 저장

    private let bboduckView = LottieAnimationView(
        name: "Timer_0",
        bundle: BboduckTimerView.toduckBundle
    ).then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
    }

    override var isRunning: Bool {
        didSet {
            if isRunning {
                // 재개 시 마지막 프레임부터 재생
                updateProgress(resumeFrame: currentFrame)
            } else {
                pause()
            }
        }
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

    private func updateProgress(resumeFrame: CGFloat? = nil) {
        let clampedProgress = min(max(progress, 0), 1)
        let stepSize = 1.0 / CGFloat(images.count)
        let imageIndex = min(Int(clampedProgress / stepSize), images.count - 1)

        guard imageIndex != preLottieIndex else { return }

        preLottieIndex = imageIndex
        let newAnimation = LottieAnimation.named(images[imageIndex], bundle: BboduckTimerView.toduckBundle)

        // 애니메이션 전환 전 현재 프레임 저장
        currentFrame = bboduckView.currentFrame

        bboduckView.animation = newAnimation
        
        // 재개 시 특정 프레임부터 시작
        if let resumeFrame = resumeFrame {
            bboduckView.currentFrame = resumeFrame
        }
        
        bboduckView.play()
    }

    public func pause() {
        // 일시 정지 시 현재 프레임 저장
        currentFrame = bboduckView.currentFrame
        
        let pauseAnimation = LottieAnimation.named(pauseImage, bundle: BboduckTimerView.toduckBundle)
        bboduckView.animation = pauseAnimation
        bboduckView.play()
        
        // 인덱스 초기화로 다음 재개 시 강제 갱신
        preLottieIndex = -1
    }
}
