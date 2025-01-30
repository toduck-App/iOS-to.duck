import TDDesign
import UIKit

protocol SocialFooterDelegate: AnyObject {
    func didTapLikeButton(_ view: SocialFooterView)
}

final class SocialFooterView: UIView {
    weak var delegate: SocialFooterDelegate?
    
    lazy var likeButton = UIButton().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.setImage(TDImage.Like.filledMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(didSelectLikeButton), for: .touchUpInside)
    }
    
    lazy var commentIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Comment.emptyMedium
    }
    
    lazy var shareIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Repeat.arrowMedium.withRenderingMode(.alwaysTemplate)
    }
    
    private var likeLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private var commentLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private var shareLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral600)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    convenience init(isLike: Bool, likeCount: Int?, commentCount: Int?, shareCount: Int?) {
        self.init(frame: .zero)
        configure(isLike: isLike, likeCount: likeCount, commentCount: commentCount, shareCount: shareCount)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(isLike: Bool, likeCount: Int?, commentCount: Int?, shareCount: Int?) {
        likeButton.tintColor = isLike ? TDColor.Primary.primary400 : TDColor.Neutral.neutral400
        likeLabel.setText("\(likeCount ?? 0)")
        configureCommentCount(with: commentCount)
        configureShareCount(with: shareCount)
    }
}

// MARK: SetupUI

private extension SocialFooterView {
    func setupConstraints() {
        for item in [likeButton, likeLabel, commentIconView, commentLabel, shareIconView, shareLabel] {
            addSubview(item)
        }
        likeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
        
        commentIconView.snp.makeConstraints { make in
            make.leading.equalTo(likeLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentIconView.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
        
        shareIconView.snp.makeConstraints { make in
            make.leading.equalTo(commentLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        shareLabel.snp.makeConstraints { make in
            make.leading.equalTo(shareIconView.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureCommentCount(with commentCount: Int?) {
        if let commentCount, commentCount > 0 {
            commentLabel.setText("\(commentCount)")
            commentIconView.isHidden = false
            commentLabel.isHidden = false
        } else {
            commentIconView.isHidden = true
            commentLabel.isHidden = true
        }
    }
    
    private func configureShareCount(with shareCount: Int?) {
        if let shareCount, shareCount > 0 {
            shareLabel.setText("\(shareCount)")
            shareIconView.isHidden = false
            shareLabel.isHidden = false
        } else {
            shareIconView.isHidden = true
            shareLabel.isHidden = true
        }
    }
}

// MARK: Delegate

extension SocialFooterView {
    @objc func didSelectLikeButton() {
        delegate?.didTapLikeButton(self)
    }
}
