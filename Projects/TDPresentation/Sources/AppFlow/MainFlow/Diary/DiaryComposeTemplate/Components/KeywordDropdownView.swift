import TDDesign
import UIKit
import SnapKit
import Then

final class KeywordDropdownView: UIView {
    private let stackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let labelView = TDLabel(
        toduckFont: TDFont.boldBody2,
        alignment: .left,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private lazy var downImage = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral800
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.downMedium.withRenderingMode(.alwaysTemplate)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI Methods
private extension KeywordDropdownView {
    func setupUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        self.layer.cornerRadius = 12
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(labelView)
        stackView.addArrangedSubview(downImage)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(12)
        }
        
        downImage.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
}

// MARK: - External Methods
extension KeywordDropdownView {
    func setTitle(_ title: String) {
        self.labelView.setText(title)
    }
    
    func setSelected(_ isSelected: Bool) {
        self.layer.borderColor = isSelected ? TDColor.Primary.primary800.cgColor : TDColor.Neutral.neutral300.cgColor
        downImage.transform = isSelected ? CGAffineTransform(rotationAngle: .pi) : .identity
    }
}
