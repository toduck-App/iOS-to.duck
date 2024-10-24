import UIKit
import SnapKit
import Then

class TDChipCell: UICollectionViewCell {
    private var chipType: TDChipType?
    private var item: TDChipItem?
    
    private var isActive: Bool = false {
        didSet {
            updateState()
        }
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let titleLabel = TDLabel(labelText: "", toduckFont: TDFont.regularBody2, toduckColor: TDColor.Neutral.neutral200)
    
    private let leftImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let rightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: TDChipItem, chipType: TDChipType, isActive: Bool) {
        self.chipType = chipType
        self.isActive = isActive
        self.item = item
        self.titleLabel.setText(item.title)
        if let leftImage = item.leftImage {
            leftImageView.image = leftImage.image
            stackView.addArrangedSubview(leftImageView)
        }
        stackView.addArrangedSubview(titleLabel)
        if let rightImage = item.rightImage {
            rightImageView.image = rightImage.image
            stackView.addArrangedSubview(rightImageView)
        }
        updateState()
    }
    
    func deSelected() {
        self.isActive = false
    }
    
    func selected() {
        self.isActive = true
    }
    
    func toggle() {
        self.isActive.toggle()
    }
    
    private func layout() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        leftImageView.image = nil
        rightImageView.image = nil
        stackView.removeArrangedSubview(leftImageView)
        stackView.removeArrangedSubview(rightImageView)
    }
    
    private func updateState() {
        guard let chipType else { return }
        contentView.layer.cornerRadius = chipType.cornerRadius
        contentView.backgroundColor = isActive ? chipType.activeBackgroundColor : chipType.inActiveBackroundColor
        titleLabel.setColor(isActive ? chipType.activeFontColor : chipType.inActiveFontColor)
        leftImageView.tintColor = isActive ? item?.leftImage?.activeColor: item?.leftImage?.inActiveColor
        rightImageView.tintColor = isActive ? item?.leftImage?.activeColor : item?.rightImage?.inActiveColor
    }
}
