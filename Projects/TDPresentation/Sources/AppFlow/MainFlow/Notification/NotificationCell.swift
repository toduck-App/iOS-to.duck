import UIKit
import TDDesign
import SnapKit
import Then

final class NotificationCell: UITableViewCell {
    // MARK: - UI Components
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    let profileImageView = UIImageView(image: TDImage.Profile.medium)
    let contentContainerView = UIView()
    let titleLabel = TDLabel(
        toduckFont: .boldBody3,
        toduckColor: TDColor.Neutral.neutral800
    )
    let timeLabel = TDLabel(
        toduckFont: .mediumBody3,
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
    
    // MARK: - Properties
    private var isRead: Bool = false
    private var isFollowed: Bool = false
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(profileImageView)
        horizontalStackView.addArrangedSubview(contentContainerView)
        horizontalStackView.addArrangedSubview(followButton)
        
        contentContainerView.addSubview(titleLabel)
        contentContainerView.addSubview(timeLabel)
        contentContainerView.addSubview(descriptionLabel)
    }
    
    // MARK: - Configuration
    func configure(
        profileImage: UIImage?,
        title: String,
        time: String,
        description: String,
        isRead: Bool,
        isFollowed: Bool
    ) {
        profileImageView.image = profileImage
        titleLabel.text = title
        timeLabel.text = time
        descriptionLabel.text = description
        self.isRead = isRead
        self.isFollowed = isFollowed
        
        backgroundColor = isRead ? TDColor.Primary.primary25 : TDColor.baseWhite
        followButton.setTitle(isFollowed ? "팔로잉" : "팔로우", for: .normal)
        followButton.backgroundColor = isFollowed ? TDColor.baseWhite : TDColor.Primary.primary500
        followButton.setTitleColor(isFollowed ? TDColor.Neutral.neutral600 : TDColor.baseWhite, for: .normal)
        followButton.layer.borderColor = isFollowed ? TDColor.Neutral.neutral300.cgColor : nil
    }
}
