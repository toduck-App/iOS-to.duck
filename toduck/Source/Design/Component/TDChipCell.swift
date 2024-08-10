import UIKit
import SnapKit
import Then

enum TDChipType {
    case capsule
    case roundedRectangle
    
    var activeColor: UIColor {
        switch self {
        case .capsule:
            return TDColor.Neutral.neutral800
        case .roundedRectangle:
            return TDColor.Neutral.neutral700
        }
    }
    
    var inactiveColor: UIColor {
        switch self {
        case .capsule:
            return TDColor.Neutral.neutral200
        case .roundedRectangle:
            return TDColor.Neutral.neutral100
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .capsule:
            return 14
        case .roundedRectangle:
            return 8
        }
    }
    
    var height: CGFloat {
        switch self {
        case .capsule:
            return 28
        case .roundedRectangle:
            return 33
        }
    }
}

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
