import TDDesign
import TDDomain
import UIKit

protocol SocialDetailCommentCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: SocialDetailCommentCell)
    func didTapMoreButton(_ cell: SocialDetailCommentCell)
    func didTapNicknameLabel(_ cell: SocialDetailCommentCell)
}

final class SocialDetailCommentCell: UICollectionViewCell {
    weak var commentDelegate: SocialDetailCommentCellDelegate?
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
    
    func configure(with comment: Comment) {}
}

// MARK: Layout

private extension SocialDetailCommentCell {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        
    }
    
    func setupConstraints() {
        
    }
}

extension SocialDetailCommentCell: SocialHeaderViewDelegate, SocialFooterDelegate {
    func didTapNickname(_ view: UIStackView) {
        commentDelegate?.didTapNicknameLabel(self)
    }
    
    func didTapMore(_ view: UIStackView) {
        commentDelegate?.didTapMoreButton(self)
    }
    
    func didTapLikeButton(_ view: SocialFooterView) {
        commentDelegate?.didTapLikeButton(self)
    }
}
