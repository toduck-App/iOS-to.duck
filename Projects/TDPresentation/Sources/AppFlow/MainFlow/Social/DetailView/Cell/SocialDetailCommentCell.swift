import Kingfisher
import SnapKit
import TDCore
import TDDesign
import TDDomain
import UIKit

// MARK: - SocialDetailCommentCell

final class SocialDetailCommentCell: UICollectionViewCell {
    weak var commentDelegate: SocialPostDelegate?
    
    private let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.cornerRadius = 12
    }
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    
    private lazy var headerView = SocialHeaderView(style: .list, isComment: true)
    
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
    
    private let replyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.alignment = .fill
        $0.distribution = .fill
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
    
    // MARK: - Configure
    
    func configure(with item: Comment) {
        setupUI()
        headerView.configure(
            titleBadge: item.user.title,
            nickname: item.user.name,
            date: item.timestamp, isMyPost: TDTokenManager.shared.userId == item.user.id
        )
        contentLabel.setText(item.content)
        footerView.configure(
            isLike: item.isLike,
            likeCount: item.likeCount,
            commentCount: item.reply.count
        )
        configureAction(item)
        configureUserImage(with: item.user.icon)
        configureCommentImage(with: item.imageURL)
        configureReplies(item.reply)
    }
    
    // MARK: - 재사용 처리
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.setText("")
        avatarView.image = TDImage.Profile.medium
        bodyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        replyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - Layout

private extension SocialDetailCommentCell {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(avatarView)
        containerView.addSubview(verticalStackView)
        bodyStackView.addArrangedSubview(contentLabel)
        verticalStackView.addArrangedSubview(headerView)
        verticalStackView.addArrangedSubview(bodyStackView)
        verticalStackView.addArrangedSubview(footerView)
        verticalStackView.addArrangedSubview(replyStackView)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
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
            make.top.equalTo(avatarView)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: Action

private extension SocialDetailCommentCell {
    func configureAction(_ item: Comment) {
        headerView.onNicknameTapped = { [weak self] in
            guard let self else { return }
            commentDelegate?.didTapNicknameLabel(self, item.user.id)
        }
        headerView.onBlockTapped = { [weak self] in
            guard let self else { return }
            commentDelegate?.didTapBlock(self, item.user.id)
        }
        headerView.onReportTapped = { [weak self] in
            guard let self else { return }
            commentDelegate?.didTapReportComment(self, item.id)
        }
        headerView.onEditTapped = { [weak self] in
            guard let self else { return }
            commentDelegate?.didTapEditComment(self, item.id)
        }
        
        headerView.onDeleteTapped = { [weak self] in
            guard let self else { return }
            commentDelegate?.didTapDeleteComment(self, item.id)
        }
        footerView.onLikeButtonTapped = { [weak self] in
            guard let self else { return }
            commentDelegate?.didTapLikeButton(self, item.id)
        }
    }
}

// MARK: - Private Methods

private extension SocialDetailCommentCell {
    // MARK: 댓글 이미지 설정
    
    func configureUserImage(with image: String?) {
        if let image, let url = URL(string: image) {
            avatarView.kf.setImage(with: url)
        } else {
            avatarView.image = TDImage.Profile.medium
        }
    }
    
    // MARK: 대댓글
    
    func configureReplies(_ replies: [Comment]) {
        for replyItem in replies {
            let replyView = createReplyView(replyItem)
            replyStackView.addArrangedSubview(replyView)
        }
    }
    
    func configureCommentImage(with imageURL: URL?) {
        guard let imageURL else { return }
        bodyStackView.addArrangedSubview(SocialImageListView(style: .scroll, images: [imageURL.absoluteString]))
    }
    
    func createReplyView(_ comment: Comment) -> UIView {
        let replyContainer = UIView()
        let replyAvatar = buildReplyAvatar(comment)
        let replyHeader = buildReplyHeader(comment)
        let replyContent = buildReplyContentLabel(comment)
        let replyFooter = buildReplyFooter(comment)
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 14
            $0.addArrangedSubview(replyHeader)
            $0.addArrangedSubview(replyContent)
        }
        
        if let imageURL = comment.imageURL {
            stackView.addArrangedSubview(SocialImageListView(style: .scroll, images: [imageURL.absoluteString]))
        }
        
        stackView.addArrangedSubview(replyFooter)
        
        replyContainer.addSubview(replyAvatar)
        replyContainer.addSubview(stackView)
        
        makeReplyAvatarConstraints(replyAvatar, in: replyContainer)
        makeReplyStackConstraints(stackView, replyAvatar: replyAvatar, in: replyContainer)
        
        return replyContainer
    }

    // MARK: 대댓글 - Subview 생성 함수들
    
    func buildReplyAvatar(_ comment: Comment) -> UIImageView {
        let avatar = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 18
            $0.clipsToBounds = true
            $0.backgroundColor = TDColor.Neutral.neutral100
        }
        // TODO: 이거 어떻게 처리할지 고민해보기
        if let icon = comment.user.icon, let url = URL(string: icon) {
            avatar.kf.setImage(with: url)
        } else {
            avatar.image = TDImage.Profile.medium
        }
        return avatar
    }
    
    func buildReplyHeader(_ comment: Comment) -> SocialHeaderView {
        let header = SocialHeaderView(style: .list).then {
            $0.configure(
                titleBadge: comment.user.title,
                nickname: comment.user.name,
                date: comment.timestamp,
                isMyPost: TDTokenManager.shared.userId == comment.user.id
            )
            $0.onNicknameTapped = { [weak self] in
                guard let self else { return }
                commentDelegate?.didTapNicknameLabel(self, comment.user.id)
            }
            $0.onBlockTapped = { [weak self] in
                guard let self else { return }
                commentDelegate?.didTapBlock(self, comment.user.id)
            }
            $0.onReportTapped = { [weak self] in
                guard let self else { return }
                commentDelegate?.didTapReportComment(self, comment.id)
            }
            $0.onEditTapped = { [weak self] in
                guard let self else { return }
                commentDelegate?.didTapEditComment(self, comment.id)
            }
            $0.onDeleteTapped = { [weak self] in
                guard let self else { return }
                commentDelegate?.didTapDeleteComment(self, comment.id)
            }
        }
        header.snp.makeConstraints { $0.height.equalTo(24) }
        return header
    }
    
    func buildReplyContentLabel(_ comment: Comment) -> TDLabel {
        let label = TDLabel(toduckFont: .regularBody4, toduckColor: TDColor.Neutral.neutral800).then {
            $0.numberOfLines = 0
            $0.setText(comment.content)
        }
        return label
    }
    
    func buildReplyFooter(_ comment: Comment) -> SocialFooterView {
        let footer = SocialFooterView(style: .compact).then {
            $0.configure(isLike: comment.isLike,
                         likeCount: comment.likeCount,
                         commentCount: nil)
        }.then {
            $0.onLikeButtonTapped = { [weak self] in
                guard let self else { return }
                commentDelegate?.didTapReplyLikeButton(self, comment.id)
            }
        }
        footer.snp.makeConstraints { $0.height.equalTo(24) }
        return footer
    }
    
    // MARK: 대댓글 - 오토레이아웃
    
    func makeReplyAvatarConstraints(_ replyAvatar: UIImageView, in container: UIView) {
        replyAvatar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.size.equalTo(36)
        }
    }
    
    func makeReplyStackConstraints(_ stackView: UIStackView,
                                   replyAvatar: UIImageView,
                                   in container: UIView)
    {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(replyAvatar)
            make.leading.equalTo(replyAvatar.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
