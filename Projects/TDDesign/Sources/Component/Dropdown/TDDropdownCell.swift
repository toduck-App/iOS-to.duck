import UIKit
import SnapKit

final class DropDownCell: UITableViewCell {
    private let stackView = UIStackView().then {
        $0.spacing = 1.5
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    
    // MARK: - UI Components
    private let optionLabel = TDLabel(labelText: "", toduckFont: TDFont.boldBody2, alignment: .center, toduckColor: TDColor.Neutral.neutral800)
    
    private let leftImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let rightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        leftImageView.image = nil
        rightImageView.image = nil
    }
    
    // MARK: - Configure
    func configure(with item: TDDropdownItem) {
        if let leftImage = item.leftImage {
            leftImageView.image = leftImage
            stackView.addArrangedSubview(leftImageView)
        }
        optionLabel.setText(item.title)
        stackView.addArrangedSubview(optionLabel)
        
        if let rightImage = item.rightImage {
            rightImageView.image = rightImage
            stackView.addArrangedSubview(rightImageView)
        }
    }
}

// MARK: - UI Methods
private extension DropDownCell {
    func setupUI() {
        backgroundColor = TDColor.baseWhite
        self.selectionStyle = .none
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        leftImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        rightImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}
