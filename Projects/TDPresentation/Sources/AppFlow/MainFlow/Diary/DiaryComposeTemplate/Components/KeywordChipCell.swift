import SnapKit
import TDDesign
import UIKit

final class KeywordChipCell: UICollectionViewCell {
    private let titleLabel = TDLabel(
        toduckFont: TDFont.mediumBody2,
        toduckColor: TDColor.Neutral.neutral700
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        }
    }
    
    private func configureUI() {
        contentView.backgroundColor = TDColor.baseWhite
        contentView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configure(text: String, isSelectedForDeletion: Bool = false) {
        titleLabel.setText(text)
        if isSelectedForDeletion {
            contentView.layer.borderColor = TDColor.Semantic.error.cgColor
            titleLabel.setColor(TDColor.Semantic.error)
            contentView.layer.borderWidth = 1
        } else {
            contentView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
            titleLabel.setColor(TDColor.Neutral.neutral700)
            contentView.layer.borderWidth = 1
        }
    }
}
