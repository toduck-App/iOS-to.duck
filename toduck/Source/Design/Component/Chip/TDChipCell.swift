import UIKit
import SnapKit
import Then

class TDChipCell: UICollectionViewCell {
    private var chipType: TDChipType = .capsule {
        didSet {
            contentView.layer.cornerRadius = chipType.cornerRadius
        }
    }
    private var isActive: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
    private let titleLabel = TDLabel(labelText: "", toduckFont: TDFont.regularBody2, toduckColor: TDColor.Neutral.neutral200)
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, chipType: TDChipType, isActive: Bool, image: UIImage? = nil) {
        self.chipType = chipType
        self.titleLabel.text = title
        self.isActive = isActive
        if let image = image {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            setImageConstraints()
        } else {
            setTitleConstraints()
        }
    }
    
    private func setTitleConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.center.equalTo(contentView)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    private func setImageConstraints() {
        imageView.snp.remakeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(8)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-8)
        } 
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview() 
        }
    }
    
    func toggle() {
        self.isActive = !isActive
        updateButtonState()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        imageView.image = nil
    }
    
    private func updateButtonState() {
        contentView.backgroundColor = isActive ? chipType.activeColor : chipType.inactiveColor
        titleLabel.textColor = isActive ? chipType.inactiveColor : chipType.activeColor
        imageView.tintColor = isActive ? chipType.inactiveColor : chipType.activeColor
    }
}
