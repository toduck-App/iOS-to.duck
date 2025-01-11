import Then
import UIKit

/// 카테고리 아이콘을 표시하는 뷰
public final class TDCategoryCircleView: UIView {
    private let categoryImageContainerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }

    private let categoryImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    public init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }
    
    /// 초기화 메서드
    /// - Parameters:
    ///   - color: 백그라운드 색상
    ///   - category: 카테고리 이미지
    public func configure(backgroundColor: UIColor, category: UIImage) {
        categoryImageContainerView.backgroundColor = backgroundColor
        categoryImageView.image = category
    }
    
    public func resetForReuse() {
        categoryImageContainerView.backgroundColor = nil
        categoryImageView.image = nil
    }
    
    private func setupView() {
        addSubview(categoryImageContainerView)
        categoryImageContainerView.addSubview(categoryImageView)
    }
    
    private func setupLayout() {
        categoryImageContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(32)
        }
        categoryImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
