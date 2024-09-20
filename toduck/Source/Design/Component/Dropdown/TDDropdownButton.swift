import UIKit
import SnapKit
import Then

protocol DropDownButtonDelegate: AnyObject {
    func didTapDropDownButton(_ button: TDDropDownButton)
}

final class TDDropDownButton: UIView {
    private let stackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let labelView = TDLabel(labelText: "", toduckFont: TDFont.boldBody2, alignment: .center, toduckColor: TDColor.Neutral.neutral700)
    
    private let downImage = UIImageView(image: UIImage(systemName: "chevron.down"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Methods
private extension TDDropDownButton {
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

// MARK: - Internal Methods
extension TDDropDownButton {
    func setTitle(_ title: String) {
        self.labelView.setText(title)
    }
}
