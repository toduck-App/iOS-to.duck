import UIKit
import TDCore
import Lottie

final class LottiePageViewController: UIPageViewController {
    private var animations: [LottieAnimation] = []
    private var pages: [UIViewController] = []
    
    // MARK: - Initializer
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        dataSource = self
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with animations: [LottieAnimation]) {
        self.animations = animations
        pages = animations.map { animation in
            let viewController = UIViewController()
            let lottieView = LottieAnimationView(animation: animation)
            lottieView.backgroundColor = .clear
            lottieView.contentMode = .scaleAspectFit
            lottieView.loopMode = .loop
            lottieView.play()
            
            viewController.view.addSubview(lottieView)
            lottieView.snp.makeConstraints { $0.edges.equalToSuperview() }
            
            return viewController
        }
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: false)
        }
    }
    
    func scrollToPage(index: Int) {
        guard index >= 0, index < pages.count else { return }
        
        let direction: NavigationDirection = (viewControllers?.first).flatMap { pages.firstIndex(of: $0) }.map {
            index >= $0 ? .forward : .reverse
        } ?? .forward
        
        setViewControllers([pages[index]], direction: direction, animated: false)
    }
}

// MARK: - UIPageViewControllerDataSource
extension LottiePageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pvc: UIPageViewController,
        viewControllerBefore vc: UIViewController
    ) -> UIViewController? {
        guard let idx = pages.firstIndex(of: vc),
              idx > 0 else { return nil }
        return pages[idx - 1]
    }
    
    func pageViewController(
        _ pvc: UIPageViewController,
        viewControllerAfter vc: UIViewController
    ) -> UIViewController? {
        guard let idx = pages.firstIndex(of: vc),
              idx + 1 < pages.count else { return nil }
        return pages[idx + 1]
    }
}
