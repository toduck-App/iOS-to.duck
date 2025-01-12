import SnapKit
import TDDesign
import UIKit

final class TagCell: UICollectionViewCell {
    private let tagLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral700
    ).then {
        $0.numberOfLines = 1
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
        backgroundColor = TDColor.Neutral.neutral50
        layer.cornerRadius = 8
    }
    
    func setupLayout() {
        contentView.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    func configure(tag: String) {
        if tag.count > 10 {
            tagLabel.setText(tag.prefix(10) + "...")
        } else {
            tagLabel.setText(tag)
        }
    }
}
