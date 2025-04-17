import Kingfisher
import SnapKit
import TDCore
import TDDesign
import TDDomain
import Then
import UIKit

final class SocialFeedCollectionViewCell: UICollectionViewCell {
    weak var socialFeedCellDelegate: SocialPostDelegate?
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    
    private lazy var headerView = SocialHeaderView(style: .list)
    
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
    
    private var contentLabel = TDLabel(toduckFont: .regularBody4, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private lazy var footerView = SocialFooterView(style: .compact)
    
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
        headerView.configure(titleBadge: item.user.title, nickname: item.user.name, date: item.timestamp, isMyPost: item.user.id == TDTokenManager.shared.userId)
        contentLabel.setText(item.contentText)
        footerView.configure(isLike: item.isLike, likeCount: item.likeCount, commentCount: item.commentCount)
        configureAction(item)
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
        contentView.addSubview(avatarView)
        contentView.addSubview(verticalStackView)
        contentView.addSubview(separatorView)
        bodyStackView.addArrangedSubview(contentLabel)
        verticalStackView.addArrangedSubview(headerView)
        verticalStackView.addArrangedSubview(bodyStackView)
        verticalStackView.addArrangedSubview(footerView)
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
        guard let image else {
            avatarView.image = TDImage.Profile.medium
            return
        }
        avatarView.kf.setImage(with: URL(string: image))
    }
    
    private func configureRoutine(with routine: Routine?) {
        guard let routine else { return }
        
        let routineView = SocialRoutineView(with: routine)
        routineView.onTapperRoutine = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapRoutineView(self, routine)
        }
        bodyStackView.addArrangedSubview(routineView)
    }
    
    private func configureImageList(with imageList: [String]?) {
        guard let imageList else { return }
        bodyStackView.addArrangedSubview(SocialImageListView(style: .regular(maxImagesToShow: 3), images: imageList))
    }
}

// MARK: Delegate

extension SocialFeedCollectionViewCell {
    func configureAction(_ item: Post) {
        headerView.onNicknameTapped = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapNicknameLabel(self, item.user.id)
        }
        
        headerView.onBlockTapped = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapBlock(self, item.user.id)
        }
        
        headerView.onReportTapped = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapReport(self, item.id)
        }
        
        headerView.onEditTapped = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapEditPost(self, item)
        }
        
        headerView.onDeleteTapped = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapDeletePost(self, item.id)
        }
        
        footerView.onLikeButtonTapped = { [weak self] in
            guard let self else { return }
            socialFeedCellDelegate?.didTapLikeButton(self, item.id)
        }
    }
}
