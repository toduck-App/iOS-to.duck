import SnapKit
import TDDesign
import TDDomain
import Then
import Kingfisher
import UIKit

protocol SocialFeedCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell)
    func didTapMoreButton(_ cell: SocialFeedCollectionViewCell)
    func didTapNicknameLabel(_ cell: SocialFeedCollectionViewCell)
    func didTapRoutineView(_ cell: SocialFeedCollectionViewCell)
}

final class SocialFeedCollectionViewCell: UICollectionViewCell {
    private let containerView = UIView()
    weak var socialFeedCellDelegate: SocialFeedCollectionViewCellDelegate?
    
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
    
    // TODO: Presentation Model
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
        bodyStackView.arrangedSubviews.forEach {
            if $0 is SocialRoutineView || $0 is SocialImageListView {
                $0.removeFromSuperview()
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
        [avatarView, verticalStackView, separatorView].forEach{
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

//MARK: Priavte Method
extension SocialFeedCollectionViewCell {
    private func configureUserImage(with image: String?) {
        if let image = image {
            avatarView.kf.setImage(with: URL(string: image))
        } else {
            avatarView.image = TDImage.Profile.medium
        }
    }
    
    private func configureRoutine(with routine: Routine?) {
        if let routine = routine {
            let routineView = SocialRoutineView(with: routine).then {
                $0.delegate = self
            }
            bodyStackView.addArrangedSubview(routineView)
        }
    }
    
    private func configureImageList(with imageList: [String]?) {
        if let imageList = imageList {
            bodyStackView.addArrangedSubview(SocialImageListView(with: imageList))
        }
    }
}

// MARK: Delegate

extension SocialFeedCollectionViewCell: SocialHeaderViewDelegate, SocialRoutineViewDelegate, SocialFooterDelegate {
    func didTapRoutine(_ view: SocialRoutineView) {
        socialFeedCellDelegate?.didTapRoutineView(self)
    }

    func didTapNickname(_ view: UIStackView) {
        socialFeedCellDelegate?.didTapNicknameLabel(self)
    }

    func didTapMore(_ view: UIStackView) {
        socialFeedCellDelegate?.didTapMoreButton(self)
    }

    @objc func didTapLikeButton() {
        socialFeedCellDelegate?.didTapLikeButton(self)
    }
    
    @objc func didTapRoutine() {
        socialFeedCellDelegate?.didTapRoutineView(self)
    }
}
