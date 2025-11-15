import UIKit
import SnapKit
import Then
import TDDesign

final class NavigationProgressView: UIView {
    var rightPageItemSize: CGSize?
    private let horizontalPadding: CGFloat = 16
    private let leftBarButtonItemSize: CGSize = CGSize(width: 44, height: 44)
    
    override var intrinsicContentSize: CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let totalHorizontalPadding: CGFloat = horizontalPadding * 2
        let rightItemWidth: CGFloat = rightPageItemSize?.width ?? CGSize(width: 44, height: 44).width
        let leftItemWidth: CGFloat = leftBarButtonItemSize.width
        let availableWidth: CGFloat = screenWidth - totalHorizontalPadding - rightItemWidth - leftItemWidth
        return CGSize(width: availableWidth, height: 8)
    }
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    private let progressView = UIProgressView(progressViewStyle: .bar).then {
        $0.progressTintColor = TDColor.Primary.primary400
        $0.trackTintColor = TDColor.Neutral.neutral200
        $0.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    /// 프로그레스 뷰의 진행 상태를 설정합니다.
    /// - Parameter progress: 0.0 ~ 1.0 사이의 진행률 값
    func configure(progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubview(progressView)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
        }
    }
}
