import SnapKit
import TDDesign
import Then
import UIKit

final class SocialCautionView: UIView {
    private let cautionImageView = UIImageView().then {
        $0.image = TDImage.warningMedium
    }
    
    private let titleLabel = TDLabel(toduckFont: .boldBody2, toduckColor: TDColor.Primary.primary500).then {
        $0.numberOfLines = 1
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    init(title: String) {
        titleLabel.setText(title)
        super.init(frame: .zero)
        self.setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addDescription(_ description: String) {
        let descriptionLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral700).then {
            $0.setText("­­­ㆍ \(description)")
        }
        stackView.addArrangedSubview(descriptionLabel)
    }
}

// MARK: Layout

private extension SocialCautionView {
    func setupUI() {
        backgroundColor = TDColor.Primary.primary25
        layer.cornerRadius = 10
        setupLayout()
        setupConstraints()
    }

    func setupLayout() {
        addSubview(cautionImageView)
        addSubview(titleLabel)
        addSubview(stackView)
    }

    func setupConstraints() {
        cautionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(cautionImageView.snp.trailing).offset(1.5)
            make.trailing.equalToSuperview().inset(16)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(cautionImageView).offset(21)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
