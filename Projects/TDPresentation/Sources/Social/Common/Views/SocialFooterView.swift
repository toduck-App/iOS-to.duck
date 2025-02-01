import TDDesign
import UIKit

protocol SocialFooterDelegate: AnyObject {
    func didTapLikeButton(_ view: SocialFooterView)
    func didTapScrapButton(_ view: SocialFooterView)
    func didTapShareButton(_ view: SocialFooterView)
}

extension SocialFooterDelegate {
    func didTapLikeButton(_ view: SocialFooterView) {}
    func didTapScrapButton(_ view: SocialFooterView) {}
    func didTapShareButton(_ view: SocialFooterView) {}
}

final class SocialFooterView: UIView {
    enum FooterStyle {
        case regular
        case compact
    }
    weak var delegate: SocialFooterDelegate?
    
    private lazy var likeButton = UIButton().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.setImage(TDImage.Like.filledMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(didSelectLikeButton), for: .touchUpInside)
    }
    
    private lazy var commentIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Comment.emptyMedium
    }
    
    private lazy var shareIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Repeat.arrowMedium.withRenderingMode(.alwaysTemplate)
    }
    
    private var likeLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private var commentLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private var shareLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private lazy var scrapButton = UIButton().then {
        $0.setImage(TDImage.Scrap.emptyMedium, for: .normal)
        $0.setImage(TDImage.Scrap.filledMedium, for: .highlighted)
        $0.addTarget(self, action: #selector(didSelectScrapButton), for: .touchUpInside)
    }
    
    private lazy var shareButton = UIButton().then {
        $0.setImage(TDImage.share2Medium, for: .normal)
        $0.addTarget(self, action: #selector(didSelectShareButton), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    /// Style에 따른 Footer Layout을 설정합니다.
    /// - Parameter style: FooterStyle
    /// Regular: Detail Post의 긴 사이즈의 Footer
    /// Compact: Feed와 Comment의 짧은 사이즈의 Footer
    convenience init(style: FooterStyle) {
        self.init(frame: .zero)
        switch style {
        case .regular:
            setupRegularConstraints()
        case .compact:
            setupCompactConstraints()
        }
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
    func setupLayout() {
        addSubview(likeButton)
        addSubview(likeLabel)
        addSubview(commentIconView)
        addSubview(commentLabel)
        addSubview(shareIconView)
        addSubview(shareLabel)
    }
    
    func setupRegularConstraints() {
        addSubview(scrapButton)
        addSubview(shareButton)
        
        commentIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentIconView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.trailing.equalTo(shareButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(scrapButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(likeLabel.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    // 일반적인 Feed와 Comment의 Footer 입니다.
    func setupCompactConstraints() {
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
    
    @objc func didSelectScrapButton() {
        delegate?.didTapScrapButton(self)
    }
    
    @objc func didSelectShareButton() {
        delegate?.didTapShareButton(self)
    }
}
