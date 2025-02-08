import TDDesign
import UIKit

final class SocialFooterView: UIView {
    enum FooterStyle {
        case regular
        case compact
    }
    var onLikeButtonTapped: (() -> Void)?
    var onScrapButtonTapped: (() -> Void)?
    var onShareButtonTapped: (() -> Void)?
    
    private lazy var likeButton = UIButton().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.setImage(TDImage.Like.filledMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addAction(UIAction { [weak self] _ in
            self?.onLikeButtonTapped?()
        }, for: .touchUpInside)
    }
    
    private lazy var scrapButton = UIButton().then {
        $0.setImage(TDImage.Scrap.emptyMedium, for: .normal)
        $0.setImage(TDImage.Scrap.filledMedium, for: .highlighted)
        $0.addAction(UIAction { [weak self] _ in
            self?.onScrapButtonTapped?()
        }, for: .touchUpInside)
    }
    
    private lazy var shareButton = UIButton().then {
        $0.setImage(TDImage.share2Medium, for: .normal)
        $0.addAction(UIAction { [weak self] _ in
            self?.onShareButtonTapped?()
        }, for: .touchUpInside)
    }
    
    private lazy var commentIconView = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.Comment.emptyMedium
    }
    
    private var likeLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral500)
    
    private var commentLabel = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral500)
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
    
    func configure(isLike: Bool, likeCount: Int?, commentCount: Int?) {
        likeButton.tintColor = isLike ? TDColor.Primary.primary400 : TDColor.Neutral.neutral400
        likeLabel.setColor(isLike ? TDColor.Primary.primary400 : TDColor.Neutral.neutral500)
        likeLabel.setText("\(likeCount ?? 0)")
        configureCommentCount(with: commentCount)
    }
}

// MARK: SetupUI

private extension SocialFooterView {
    func setupLayout() {
        addSubview(likeButton)
        addSubview(likeLabel)
        addSubview(commentIconView)
        addSubview(commentLabel)
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
        commentIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentIconView.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(commentLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(2)
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
}
