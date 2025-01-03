import Kingfisher
import SnapKit
import TDDesign
import TDDomain
import Then
import UIKit

protocol SocialFeedCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell)
    func didTapNicknameLabel(_ cell: SocialFeedCollectionViewCell)
    func didTapRoutineView(_ cell: SocialFeedCollectionViewCell)
    func didTapReport(_ cell: SocialFeedCollectionViewCell)
    func didTapBlock(_ cell: SocialFeedCollectionViewCell)
}

final class SocialFeedCollectionViewCell: UICollectionViewCell {
    weak var socialFeedCellDelegate: SocialFeedCollectionViewCellDelegate?
    
    private let containerView = UIView()
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    
    private lazy var headerView = SocialHeaderView().then {
        $0.delegate = self
    }
    
    private var bodyStackView = UIStackView().then {
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
    
    private lazy var footerView = SocialFooterView(isLike: false, likeCount: nil, commentCount: nil, shareCount: nil).then {
        $0.delegate = self
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
    
    func configure(with item: Post) {
        headerView.configure(titleBadge: item.user.title, nickname: item.user.name, date: item.timestamp)
        contentLabel.setText(item.contentText)
        footerView.configure(isLike: item.isLike, likeCount: item.likeCount, commentCount: item.commentCount, shareCount: item.shareCount)
        
        configureUserImage(with: item.user.icon)
        configureRoutine(with: item.routine)
        configureImageList(with: item.imageList)
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

private extension SocialFeedCollectionViewCell {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        addSubview(containerView)
        for item in [avatarView, verticalStackView, separatorView] {
            containerView.addSubview(item)
        }
        bodyStackView.addArrangedSubview(contentLabel)
        
        for item in [headerView, bodyStackView, footerView] {
            verticalStackView.addArrangedSubview(item)
        }
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
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
        
        footerView.snp.makeConstraints { make in
            make.height.equalTo(24)
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

extension SocialFeedCollectionViewCell {
    private func configureUserImage(with image: String?) {
        if let image {
            avatarView.kf.setImage(with: URL(string: image))
        } else {
            avatarView.image = TDImage.Profile.medium
        }
    }
    
    private func configureRoutine(with routine: Routine?) {
        if let routine {
            let routineView = SocialRoutineView(with: routine).then {
                $0.delegate = self
            }
            bodyStackView.addArrangedSubview(routineView)
        }
    }
    
    private func configureImageList(with imageList: [String]?) {
        if let imageList {
            bodyStackView.addArrangedSubview(SocialImageListView(with: imageList))
        }
    }
}

// MARK: Delegate

extension SocialFeedCollectionViewCell: SocialHeaderViewDelegate, SocialRoutineViewDelegate, SocialFooterDelegate {
    func didTapReport(_ view: UIView) {
        socialFeedCellDelegate?.didTapReport(self)
    }

    func didTapBlock(_ view: UIView) {
        socialFeedCellDelegate?.didTapBlock(self)
    }

    func didTapRoutine(_ view: SocialRoutineView) {
        socialFeedCellDelegate?.didTapRoutineView(self)
    }

    func didTapNickname(_ view: UIView) {
        socialFeedCellDelegate?.didTapNicknameLabel(self)
    }

    @objc func didTapLikeButton(_ view: SocialFooterView) {
        socialFeedCellDelegate?.didTapLikeButton(self)
    }
}
