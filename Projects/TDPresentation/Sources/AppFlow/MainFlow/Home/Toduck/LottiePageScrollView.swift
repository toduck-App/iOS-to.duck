import UIKit
import TDCore
import Lottie

final class LottiePageScrollView: UIScrollView {
    private var lottieViews: [LottieAnimationView] = []
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    
    func configure(with animations: [LottieAnimation]) {
        lottieViews.forEach { $0.removeFromSuperview() }
        lottieViews.removeAll()
        
        animations.enumerated().forEach { index, animation in
            let lottieView = LottieAnimationView(animation: animation)
            lottieView.loopMode = .loop
            lottieView.play()
            lottieView.contentMode = .scaleAspectFit
            lottieView.backgroundColor = .clear
            
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
