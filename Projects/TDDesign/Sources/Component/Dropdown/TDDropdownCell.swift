import SnapKit
import UIKit

final class DropDownCell: UITableViewCell {
    private var item: TDDropdownItem?
    
    private let stackView = UIStackView().then {
        $0.spacing = 4
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    
    // MARK: - UI Components

    private let optionLabel = TDLabel(toduckFont: TDFont.mediumBody2, alignment: .center, toduckColor: TDColor.Neutral.neutral800)
    
    private let leftImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = TDColor.Neutral.neutral400
    }
    
    private let rightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = TDColor.Neutral.neutral400
    }
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.item = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for arrangedSubview in stackView.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
        self.item = nil
        leftImageView.image = nil
        rightImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        stackView.backgroundColor = selected ? TDColor.Primary.primary50 : TDColor.baseWhite
        leftImageView.image = selected ? item?.leftImage?.selectedImage : item?.leftImage?.defaultImage
        rightImageView.image = selected ? item?.rightImage?.selectedImage : item?.rightImage?.defaultImage
        optionLabel.setColor(selected ? TDColor.Primary.primary500 : TDColor.Neutral.neutral800)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        stackView.backgroundColor = highlighted ? TDColor.Primary.primary50 : TDColor.baseWhite
        leftImageView.image = highlighted ? item?.leftImage?.selectedImage : item?.leftImage?.defaultImage
        rightImageView.image = highlighted ? item?.rightImage?.selectedImage : item?.rightImage?.defaultImage
        optionLabel.setColor(highlighted ? TDColor.Primary.primary500 : TDColor.Neutral.neutral800)
    }
    
    // MARK: - Configure

    func configure(with item: TDDropdownItem) {
        self.item = item
        if let leftImage = item.leftImage {
            leftImageView.image = leftImage.defaultImage
            stackView.addArrangedSubview(leftImageView)
        }
        optionLabel.setText(item.title)
        stackView.addArrangedSubview(optionLabel)
        
        if let rightImage = item.rightImage {
            rightImageView.image = rightImage.defaultImage
            stackView.addArrangedSubview(rightImageView)
        }
    }
}

// MARK: - UI Methods

private extension DropDownCell {
    func setupUI() {
        backgroundColor = TDColor.baseWhite
        stackView.layer.cornerRadius = 8
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
    }
}
