import SnapKit
import Then
import UIKit

public final class TDFormCategoryView: UIView {
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    private let categoryHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    public init() {
        super.init(frame: .zero)
        setupStackView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        addSubview(scrollView)
        scrollView.addSubview(categoryHorizontalStackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        categoryHorizontalStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    public func setupCategoryView(categories: [(UIColor, UIImage)]) {
        categories.forEach { color, image  in
            let categoryView = TDCategoryCircleView()
            categoryView.snp.makeConstraints { $0.width.height.equalTo(50) }
            categoryView.configure(radius: 25, backgroundColor: color, category: image)
            categoryHorizontalStackView.addArrangedSubview(categoryView)
        }
    }
}
