import SnapKit
import TDDesign
import Then
import UIKit

final class SocialFooterView: UIView {
    enum FooterStyle {
        case regular
        case compact
    }
    
    // MARK: - Callback Closures

    var onLikeButtonTapped: (() -> Void)?
    var onScrapButtonTapped: (() -> Void)?
    var onShareButtonTapped: (() -> Void)?
    
    // MARK: - UI Elements

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
    
    private lazy var likeLabel: TDLabel = .init(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral500)
    
    private lazy var commentLabel: TDLabel = .init(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral500)
    
    // MARK: - Stack Views

    private var mainStackView: UIStackView!
    private let style: FooterStyle
    
    // MARK: - Init

    init(style: FooterStyle) {
        self.style = style
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        self.style = .regular // 기본값
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Layout Setup

    private func setupLayout() {
        switch style {
        case .regular:
            setupRegularLayout()
        case .compact:
            setupCompactLayout()
        }
    }
    
    private func setupRegularLayout() {
        let leftStack = UIStackView(arrangedSubviews: [commentIconView, commentLabel]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }
        
        let rightStack = UIStackView(arrangedSubviews: [likeButton, likeLabel, scrapButton, shareButton]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.setCustomSpacing(4, after: likeButton)
            $0.setCustomSpacing(10, after: likeLabel)
            $0.setCustomSpacing(10, after: scrapButton)
        }
        let spacerView = UIView().then {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        mainStackView = UIStackView(arrangedSubviews: [leftStack, spacerView, rightStack]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 0
        }
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    }
    
    private func setupCompactLayout() {
        mainStackView = UIStackView(arrangedSubviews: [commentIconView, commentLabel, likeButton, likeLabel]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.setCustomSpacing(2, after: commentIconView)
            $0.setCustomSpacing(10, after: commentLabel)
            $0.setCustomSpacing(2, after: likeButton)
            $0.distribution = .fill
        }
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    }
    
    // MARK: - Configuration

    /// isLike, likeCount, commentCount에 따라 각 요소를 업데이트합니다.
    /// - Parameters:
    ///   - isLike: 좋아요 상태 여부
    ///   - likeCount: 좋아요 개수 (nil이면 좋아요 라벨 숨김)
    ///   - commentCount: 댓글 개수 (nil 또는 0이면 댓글 아이콘/라벨 숨김)
    func configure(isLike: Bool, likeCount: Int?, commentCount: Int?) {
        likeButton.tintColor = isLike ? TDColor.Primary.primary400 : TDColor.Neutral.neutral400
        likeLabel.setColor(isLike ? TDColor.Primary.primary400 : TDColor.Neutral.neutral500)
        if let likeCount {
            likeLabel.setText("\(likeCount)")
            likeLabel.isHidden = false
        } else {
            likeLabel.isHidden = true
        }
        
        if let commentCount, commentCount >= 0 {
            commentLabel.setText("\(commentCount)")
            commentIconView.isHidden = false
            commentLabel.isHidden = false
        } else {
            commentIconView.isHidden = true
            commentLabel.isHidden = true
        }
    }
}
