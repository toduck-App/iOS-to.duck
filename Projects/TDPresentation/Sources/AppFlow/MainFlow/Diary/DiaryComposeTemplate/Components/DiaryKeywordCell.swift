import SnapKit
import TDDesign
import UIKit

final class DiaryKeywordCell: UICollectionViewCell {
    private let tagLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral700
    ).then {
        $0.numberOfLines = 1
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        backgroundColor = TDColor.Neutral.neutral100
        layer.cornerRadius = 8
    }
    
    func setupLayout() {
        contentView.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    func configure(keyword: String, isSelected: Bool) {
        tagLabel.setText(keyword)
        isSelected ? tagLabel.setColor(TDColor.Primary.primary500) : tagLabel.setColor(TDColor.Neutral.neutral700)
        isSelected ? (backgroundColor = TDColor.Primary.primary100) : (backgroundColor = TDColor.Neutral.neutral100)
    }
}
