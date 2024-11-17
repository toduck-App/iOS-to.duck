import TDDesign
import TDDomain
import UIKit

protocol SocialDetailCommentCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: SocialDetailCommentCell)
    func didTapNicknameLabel(_ cell: SocialDetailCommentCell)
}

final class SocialDetailCommentCell: UICollectionViewCell {
    weak var commentDelegate: SocialDetailCommentCellDelegate?
    
    private let containerView = UIView()
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    
    lazy private var headerView = SocialHeaderView().then{
        $0.delegate = self
    }
    
    private var bodyStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 14
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    lazy var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    private var contentLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    lazy private var footerView = SocialFooterView(isLike: false, likeCount: nil, commentCount: nil, shareCount: nil).then {
        $0.delegate = self
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
    
    func configure(with item: Comment) {
        headerView.configure(titleBadge: item.user.title, nickname: item.user.name, date: item.timestamp)
        contentLabel.setText(item.content)
        footerView.configure(isLike: item.isLike, likeCount: item.like, commentCount: nil, shareCount: nil)
        configureUserImage(with: item.user.icon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.setText("")
        avatarView.image = TDImage.Profile.medium
        bodyStackView.arrangedSubviews.forEach {
            if $0 is SocialRoutineView || $0 is SocialImageListView {
                $0.removeFromSuperview()
            }
        }
    }
}

// MARK: Layout

private extension SocialDetailCommentCell {
    func setupUI() {
        backgroundColor = TDColor.baseWhite
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        addSubview(containerView)
        [avatarView, verticalStackView].forEach{
            containerView.addSubview($0)
        }
        bodyStackView.addArrangedSubview(contentLabel)
        
        [headerView, bodyStackView, footerView].forEach{
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
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
        
        footerView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: Private Method

private extension SocialDetailCommentCell {
    func configureUserImage(with image: String?) {
        if let image = image {
            avatarView.kf.setImage(with: URL(string: image))
        } else {
            avatarView.image = TDImage.Profile.medium
        }
    }
}

extension SocialDetailCommentCell: SocialHeaderViewDelegate, SocialFooterDelegate {
    func didTapReport(_ view: UIView) {
        print("didTapReport")
    }

    func didTapBlock(_ view: UIView) {
        print("didTapBlock")
    }

    func didTapNickname(_ view: UIView) {
        commentDelegate?.didTapNicknameLabel(self)
    }
    
    func didTapLikeButton(_ view: SocialFooterView) {
        commentDelegate?.didTapLikeButton(self)
    }
}
