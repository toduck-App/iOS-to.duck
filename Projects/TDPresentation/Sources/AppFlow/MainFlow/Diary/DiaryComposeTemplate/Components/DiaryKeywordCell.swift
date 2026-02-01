import SnapKit
import TDDesign
import UIKit

final class DiaryKeywordCell: UICollectionViewCell {
    enum Mode {
        case normal
        case remove
    }
    
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
        contentView.backgroundColor = TDColor.Neutral.neutral100
        contentView.layer.cornerRadius = 8
    }

    func setupLayout() {
        contentView.addSubview(tagLabel)

        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
            make.height.equalTo(20)
        }
    }
    
    func configure(mode: Mode, keyword: String, isSelected: Bool) {
        switch mode {
        case .normal:
            normalConfigure(keyword: keyword, isSelected: isSelected)
        case .remove:
            removeConfigure(keyword: keyword, isSelected: isSelected)
        }
    }
    
    private func normalConfigure(keyword: String, isSelected: Bool) {
        tagLabel.setText(keyword)
        isSelected ? tagLabel.setColor(TDColor.Primary.primary500) : tagLabel.setColor(TDColor.Neutral.neutral700)
        contentView.backgroundColor = isSelected ? TDColor.Primary.primary100 : TDColor.Neutral.neutral100
        contentView.layer.borderColor = nil
        contentView.layer.borderWidth = 0
    }

    private func removeConfigure(keyword: String, isSelected: Bool) {
        tagLabel.setText(keyword)
        isSelected ? tagLabel.setColor(TDColor.Semantic.error) : tagLabel.setColor(TDColor.Neutral.neutral700)
        contentView.layer.borderColor = isSelected ? TDColor.Semantic.error.cgColor : nil
        contentView.layer.borderWidth = isSelected ? 1 : 0
        contentView.backgroundColor = isSelected ? TDColor.baseWhite : TDColor.Neutral.neutral100
    }
}
