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
    let profileImageContainerView = UIView()
    let profileImageView = UIImageView(image: TDImage.Profile.large).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    let profileDescriptionImageView = UIImageView()
    let contentVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 8
    }

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
    let followButton = UIButton(type: .system)
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.attributedText = nil
        timeLabel.text = nil
        descriptionLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.isHidden = false
        backgroundColor = TDColor.baseWhite
        profileImageView.image = TDImage.Profile.large
    }
    
    // MARK: - Setup UI
    private func addView() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(profileImageContainerView)
        profileImageContainerView.addSubview(profileImageView)
        profileImageContainerView.addSubview(profileDescriptionImageView)
        
        horizontalStackView.addArrangedSubview(contentVerticalStackView)
        horizontalStackView.addArrangedSubview(followButton)
        
        contentVerticalStackView.addArrangedSubview(titleTimeContainer)
        contentVerticalStackView.addArrangedSubview(descriptionLabel)
        
        titleTimeContainer.addSubview(titleLabel)
        titleTimeContainer.addSubview(timeLabel)
    }
    
    private func layout() {
        horizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        profileImageContainerView.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        profileDescriptionImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(2)
        }
        
        contentVerticalStackView.snp.makeConstraints {
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
        type: String,
        description: String?,
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
        if let description, !description.isEmpty {
            descriptionLabel.setText(description)
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        
        backgroundColor = isRead ? TDColor.baseWhite : TDColor.Primary.primary25
        
        if type == "FOLLOW" {
            profileDescriptionImageView.image = TDImage.Profile.profileFollow
        } else if type == "LIKE_POST" || type == "LIKE_COMMENT" {
            profileDescriptionImageView.image = TDImage.Profile.profileLike
        } else {
            profileDescriptionImageView.image = TDImage.Profile.profileComment
        }
            
        
        if let isFollowed {
            followButton.setTitle(isFollowed ? "팔로잉" : "팔로우", for: .normal)
            followButton.titleLabel?.font = TDFont.boldBody2.font
            
            if isFollowed {
                followButton.backgroundColor = TDColor.baseWhite
                followButton.setTitleColor(TDColor.Neutral.neutral600, for: .normal)
                followButton.layer.borderWidth = 1
                followButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                followButton.layer.cornerRadius = 8
            } else {
                followButton.backgroundColor = TDColor.Primary.primary500
                followButton.setTitleColor(TDColor.baseWhite, for: .normal)
                followButton.layer.borderWidth = 0
                followButton.layer.borderColor = nil
                followButton.layer.cornerRadius = 8
            }
        } else {
            followButton.isHidden = true
        }
    }
    
    func configureFollowButton(action: @escaping () -> Void) {
        followButton.addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)
    }
}
