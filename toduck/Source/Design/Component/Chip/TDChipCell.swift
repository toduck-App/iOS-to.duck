import UIKit
import SnapKit
import Then



class TDChipCell: UICollectionViewCell {
    
    private var chipType: TDChipType = .capsule
    private var isActive: Bool = false
    
    private let titleLabel = TDLabel(labelText: "", toduckFont: TDFont.regularBody2, toduckColor: TDColor.Neutral.neutral200)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, chipType: TDChipType, isActive: Bool) {
        self.chipType = chipType
        self.titleLabel.text = title
        contentView.layer.cornerRadius = chipType.cornerRadius
        self.isActive = isActive
        updateButtonState()
    }
    
    func toggle() {
        self.isActive = !isActive
        updateButtonState()
    }
    
    private func updateButtonState() {
        contentView.backgroundColor = isActive ? chipType.activeColor : chipType.inactiveColor
        titleLabel.textColor = isActive ? chipType.inactiveColor : chipType.activeColor
    }
}
