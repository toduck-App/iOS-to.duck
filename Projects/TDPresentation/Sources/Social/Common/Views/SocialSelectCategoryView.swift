import SnapKit
import TDDesign
import Then
import UIKit

final class SocialSelectCategoryView: UIView {
    private let title = TDRequiredTitle().then {
        $0.setTitleLabel("카테고리")
        $0.setRequiredLabel()
    }

    private(set) lazy var categorySelectView = TDChipCollectionView(
        chipType: .init(
            backgroundColor: .init(
                activeColor: TDColor.Primary.primary500,
                inActiveColor: TDColor.baseWhite
            ),
            fontColor: .init(
                activeColor: TDColor.baseWhite,
                inActiveColor: TDColor.Neutral.neutral700
            ),
            cornerRadius: 8,
            height: 33
        ),
        hasAllSelectChip: false,
        isMultiSelect: false
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocialSelectCategoryView {
    private func setLayout() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(title)
        addSubview(categorySelectView)
    }
    
    private func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        categorySelectView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
