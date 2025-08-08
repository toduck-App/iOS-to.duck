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
        defaultLottieView.removeFromSuperview()
        defaultLottieView.stop()
        defaultLottieView.animation = nil
        lottieViews.forEach { $0.removeFromSuperview() }
        lottieViews.removeAll()
        
        animations.enumerated().forEach { index, animation in
            let lottieView = LottieAnimationView(animation: animation)
            lottieView.contentMode = .scaleAspectFit
            lottieView.backgroundColor = .clear
            lottieView.loopMode = .loop
            lottieView.play()
            
            addSubview(lottieView)
            lottieViews.append(lottieView)
            
            lottieView.snp.makeConstraints {
                $0.top.bottom.size.equalToSuperview()
                
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(lottieViews[index - 1].snp.trailing)
                }
                if index == animations.count - 1 {
                    $0.trailing.equalToSuperview()
                }
            }
        }
    }
}
