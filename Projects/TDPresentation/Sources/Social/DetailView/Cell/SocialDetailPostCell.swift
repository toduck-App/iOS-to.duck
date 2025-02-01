import Kingfisher
import SnapKit
import TDDesign
import TDDomain
import Then
import UIKit

final class SocialDetailPostCell: UICollectionViewCell {
    weak var socialDetailPostCellDelegate: SocialPostDelegate?
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fill
    }
    
    private lazy var headerView = SocialHeaderView(style: .detail).then {
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
    
    private var titleLabel = TDLabel(toduckFont: .boldBody1, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private var contentLabel = TDLabel(toduckFont: .regularBody4, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 0
    }
    
    private let seperatorView = UIView.dividedLine()
    
    private lazy var footerView = SocialFooterView(style: .regular).then {
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
    
    func configure(with item: Post) {
        headerView.configure(titleBadge: item.user.title, nickname: item.user.name, date: item.timestamp)
        if let title = item.titleText {
            titleLabel.setText(title)
        } else {
            titleLabel.isHidden = true
        }
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

private extension SocialDetailPostCell {
    func setupUI() {
        backgroundColor = TDColor.baseWhite
        clipsToBounds = true
        layer.cornerRadius = 12
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        contentView.addSubview(avatarView)
        contentView.addSubview(headerView)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(bodyStackView)
        verticalStackView.addArrangedSubview(seperatorView)
        verticalStackView.addArrangedSubview(footerView)
        bodyStackView.addArrangedSubview(titleLabel)
        bodyStackView.addArrangedSubview(contentLabel)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        avatarView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(36)
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(avatarView)
            make.height.equalTo(36)
        }
        
        bodyStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: Priavte Method

extension SocialDetailPostCell {
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

extension SocialDetailPostCell: SocialHeaderViewDelegate, SocialRoutineViewDelegate, SocialFooterDelegate {
    func didTapReport(_ view: UIView) {
        print("didTapReport")
    }

    func didTapBlock(_ view: UIView) {
        print("didTapBlock")
    }

    func didTapRoutine(_ view: SocialRoutineView) {
        socialDetailPostCellDelegate?.didTapRoutineView(self)
    }

    func didTapNickname(_ view: UIView) {
        socialDetailPostCellDelegate?.didTapNicknameLabel(self)
    }

    @objc func didTapLikeButton(_ view: SocialFooterView) {
        socialDetailPostCellDelegate?.didTapLikeButton(self)
    }
}
