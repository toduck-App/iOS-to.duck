import UIKit
import TDDesign
import SnapKit
import Then

final class NotificationCell: UITableViewCell {
    // MARK: - UI Components
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    let profileImageView = UIImageView(image: TDImage.Profile.medium).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    let contentContainerView = UIView()

    let titleTimeContainer = UIView()
    let titleLabel = TDLabel(
        toduckFont: .boldBody3,
        toduckColor: TDColor.Neutral.neutral800
    )
    let timeLabel = TDLabel(
        toduckFont: .regularBody3,
        toduckColor: TDColor.Neutral.neutral600
    )
    let descriptionLabel = TDLabel(
        toduckFont: .boldBody3,
        toduckColor: TDColor.Neutral.neutral600
    )
    let followButton = TDBaseButton(
        title: "팔로우",
        radius: 8
    )
    
    // MARK: - Initializer
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func addView() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(profileImageView)
        horizontalStackView.addArrangedSubview(contentContainerView)
        horizontalStackView.addArrangedSubview(followButton)
        
        contentContainerView.addSubview(titleTimeContainer)
        contentContainerView.addSubview(descriptionLabel)
        
        titleTimeContainer.addSubview(titleLabel)
        titleTimeContainer.addSubview(timeLabel)
    }
    
    private func layout() {
        horizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(followButton.snp.leading).offset(-10)
        }
        titleTimeContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleTimeContainer.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        followButton.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(32)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configuration
    func configure(
        senderName: String,
        title: String,
        time: String,
        description: String,
        isRead: Bool,
        isFollowed: Bool?
    ) {
        let attributedTitle = NSMutableAttributedString(
            string: title,
            attributes: [.font: TDFont.mediumBody3.font]
        )
        
        if let range = title.range(of: senderName) {
            let nsRange = NSRange(range, in: title)
            attributedTitle.addAttributes([
                .font: TDFont.boldBody3.font
            ], range: nsRange)
        }
        
        titleLabel.attributedText = attributedTitle
        timeLabel.setText(time)
        descriptionLabel.setText(description)
        
        backgroundColor = isRead ? TDColor.baseWhite : TDColor.Primary.primary25
        
        if let isFollowed {
            followButton.setTitle(isFollowed ? "팔로잉" : "팔로우", for: .normal)
            followButton.backgroundColor = isFollowed ? TDColor.baseWhite : TDColor.Primary.primary500
            followButton.setTitleColor(isFollowed ? TDColor.Neutral.neutral600 : TDColor.baseWhite, for: .normal)
            followButton.layer.borderColor = isFollowed ? TDColor.Neutral.neutral300.cgColor : nil
        } else {
            followButton.isHidden = true
        }
    }
}
