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
    
    // 고정된 이미지 배열
    private let categoryImages: [UIImage] = [
        TDImage.Category.computer,  // 컴퓨터
        TDImage.Category.food,      // 밥
        TDImage.Category.pencil,    // 연필
        TDImage.Category.redBook,   // 빨간책
        TDImage.Category.yellowBook,// 노란책
        TDImage.Category.sleep,     // 물
        TDImage.Category.power,     // 운동
        TDImage.Category.people,    // 사람
        TDImage.Category.medicine,  // 약
        TDImage.Category.talk,      // 채팅
        TDImage.Category.heart,     // 하트
        TDImage.Category.vehicle,   // 차
        TDImage.Category.none       // None
    ]
    
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
    
    // 색상 배열만 받도록 변경
    public func setupCategoryView(colors: [UIColor]) {
        for (index, color) in colors.enumerated() {
            let categoryView = TDCategoryCircleView()
            categoryView.snp.makeConstraints { $0.width.height.equalTo(50) }
            categoryView.setCategoryImageInsets(12)
            categoryView.configure(
                radius: 25,
                backgroundColor: color,
                category: categoryImages[index]
            )
            categoryHorizontalStackView.addArrangedSubview(categoryView)
        }
    }
}
