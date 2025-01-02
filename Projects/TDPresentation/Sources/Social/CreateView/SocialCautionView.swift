import SnapKit
import TDDesign
import Then
import UIKit

final class SocialCautionView: UIView {
    enum SocialCautionStyle {
        case warning
        case notice
    }
    
    private let cautionImageView = UIImageView()
    
    private let titleLabel = TDLabel(toduckFont: .boldBody2, toduckColor: TDColor.Primary.primary500).then {
        $0.numberOfLines = 1
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    init(style: SocialCautionStyle, title: String) {
        super.init(frame: .zero)
        setupStyle(style: style, title: title)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addDescription(_ description: String) {
        let descriptionLabel = TDLabel(toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral700).then {
            $0.setText("­­­ㆍ \(description)")
            $0.numberOfLines = 0
        }
        stackView.addArrangedSubview(descriptionLabel)
    }
}

// MARK: Layout

private extension SocialCautionView {
    func setupStyle(style: SocialCautionStyle, title: String) {
        titleLabel.setText(title)
        switch style {
        case .warning:
            titleLabel.setColor(TDColor.Neutral.neutral600)
            cautionImageView.image = TDImage.warningMedium.withRenderingMode(.alwaysTemplate)
            cautionImageView.tintColor = TDColor.Neutral.neutral500
            backgroundColor = TDColor.Neutral.neutral50
        case .notice:
            titleLabel.setColor(TDColor.Primary.primary500)
            cautionImageView.image = TDImage.warningCheckMedium
            backgroundColor = TDColor.Primary.primary25
        }
    }
    
    func setupUI() {
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
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(cautionImageView.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(cautionImageView)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(cautionImageView)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
