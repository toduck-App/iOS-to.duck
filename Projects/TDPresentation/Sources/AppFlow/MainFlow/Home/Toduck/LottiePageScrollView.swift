import UIKit
import TDCore
import Lottie

final class LottiePageScrollView: UIScrollView {
    private let defaultLottieView = LottieAnimationView(
        name: "toduckNoTodo",
        bundle: Bundle(identifier: Constant.toduckDesignBundle)!
    ).then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
    }
    
    private var lottieViews: [LottieAnimationView] = []
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setup()
        configureDefaultLottieView()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    private func configureDefaultLottieView() {
        addSubview(defaultLottieView)
        defaultLottieView.snp.makeConstraints {
            $0.edges.equalTo(self.contentLayoutGuide)
            $0.size.equalTo(self.frameLayoutGuide)
        }
        defaultLottieView.play()
    }
    
    // MARK: - Configuration
    func configure(with animations: [LottieAnimation]) {
        clearLottieViews()
        
        if animations.isEmpty {
            configureDefaultLottieView()
        } else {
            removeDefaultLottieView()
            addLottieAnimations(animations)
        }
    }
    
    private func clearLottieViews() {
        lottieViews.forEach { $0.removeFromSuperview() }
        lottieViews.removeAll()
    }
    
    private func removeDefaultLottieView() {
        defaultLottieView.removeFromSuperview()
        defaultLottieView.stop()
        defaultLottieView.animation = nil
    }
    
    private func addLottieAnimations(_ animations: [LottieAnimation]) {
        animations.enumerated().forEach { index, animation in
            let lottieView = createLottieView(for: animation)
            setupLottieViewConstraints(lottieView, index: index, totalCount: animations.count)
            lottieViews.append(lottieView)
        }
    }
    
    private func createLottieView(for animation: LottieAnimation) -> LottieAnimationView {
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.contentMode = .scaleAspectFit
        lottieView.backgroundColor = .clear
        lottieView.loopMode = .loop
        lottieView.play()
        addSubview(lottieView)
        return lottieView
    }
    
    private func setupLottieViewConstraints(_ lottieView: LottieAnimationView, index: Int, totalCount: Int) {
        lottieView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.contentLayoutGuide)
            $0.size.equalTo(self.frameLayoutGuide)
            
            if index == 0 {
                $0.leading.equalTo(self.contentLayoutGuide)
            } else {
                $0.leading.equalTo(lottieViews[index - 1].snp.trailing)
            }
            
            if index == totalCount - 1 {
                $0.trailing.equalTo(self.contentLayoutGuide)
            }
        }
    }
}
