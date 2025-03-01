import TDDesign
import UIKit
import SnapKit
import Then

final class SocialListDropdownView: UIView {
    private let stackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let labelView = TDLabel(
        toduckFont: TDFont.boldBody2,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral700
    )
    
    private lazy var downImage = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
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
private extension SocialListDropdownView {
    func setupUI() {
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
            make.edges.equalToSuperview()
        }
        
        downImage.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
}

// MARK: - External Methods
extension SocialListDropdownView {
    func setTitle(_ title: String) {
        self.labelView.setText(title)
    }
}
