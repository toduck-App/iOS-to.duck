import UIKit
import SnapKit

final class DropDownCell: UITableViewCell {
    static let identifier = "DropDownCell"
    
    override var isSelected: Bool {
        didSet {
            optionLabel.textColor = isSelected ? .black : .systemGray2
        }
    }
    
    // MARK: - UI Components
    private let optionLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(with text: String) {
        optionLabel.text = text
    }
}

// MARK: - UI Methods
private extension DropDownCell {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        contentView.addSubview(optionLabel)
    }
    
    func setConstraints() {
        optionLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
    }
}
