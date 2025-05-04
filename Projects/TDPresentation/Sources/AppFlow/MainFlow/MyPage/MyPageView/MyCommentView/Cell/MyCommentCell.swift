import Kingfisher
import SnapKit
import TDCore
import TDDesign
import TDDomain
import Then
import UIKit

final class MyCommentCell: UICollectionViewCell {
    weak var socialFeedCellDelegate: SocialPostDelegate?
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    
    private lazy var headerView = SocialHeaderView(style: .detail)
    
    private var bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    private var textContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private var contentLabel = TDLabel(toduckFont: .regularBody4, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public func configure(with item: Comment) {
        headerView.configure(
            titleBadge: item.user.title,
            nickname: item.user.name,
            date: item.timestamp,
            isMyPost: item.user.id == TDTokenManager.shared.userId
        )
        
        contentLabel.setText(item.content)
        
        configureUserImage(with: item.user.icon)
        guard let imageURLString = item.imageURL?.absoluteString else { return }
        configureImageList(with: [imageURLString])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.setText("")
        avatarView.image = TDImage.Profile.medium
        for arrangedSubview in bodyStackView.arrangedSubviews {
            if arrangedSubview is SocialRoutineView || arrangedSubview is SocialImageListView {
                arrangedSubview.removeFromSuperview()
            }
        }
    }
}

// MARK: Layout

private extension MyCommentCell {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        contentView.addSubview(avatarView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(separatorView)
        textContainerView.addArrangedSubview(contentLabel)
        bodyStackView.addArrangedSubview(textContainerView)
        verticalStackView.addArrangedSubview(headerView)
        verticalStackView.addArrangedSubview(bodyStackView)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview()
        }
        
        avatarView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(36)
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        bodyStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

// MARK: Priavte Method

extension MyCommentCell {
    private func configureUserImage(with image: String?) {
        guard let image else {
            avatarView.image = TDImage.Profile.medium
            return
        }
        avatarView.kf.setImage(with: URL(string: image))
    }
    
    private func configureImageList(with imageList: [String]?) {
        guard let imageList else { return }
        bodyStackView.addArrangedSubview(
            SocialImageListView(
                style: .scroll,
                images: imageList
            )
        )
    }
}
