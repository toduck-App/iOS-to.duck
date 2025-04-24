//
//  MyPageProfileView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/7/25.
//

import SnapKit
import UIKit
import TDDesign

final class MyPageProfileView: BaseView {
    private let containerView = UIView()
    
    // MARK: 기존 Profile Avatar View가 사용되지 않고 있습니다.
    // private let profileImageView = TDImageView()

    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = TDImage.Profile.large
    }

    private let innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = LayoutConstants.innerStackViewSpacing
        return stackView
    }()

    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = LayoutConstants.userInfoStackViewSpacing
        return stackView
    }()

    let usernameLabel = TDLabel(toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)

    private let badgeLabels: [BadgeLabel] = [BadgeLabel(text: "작심삼잉")]

    private let followInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = LayoutConstants.followInfoStackViewSpacing
        return stackView
    }()
    
    private var isProfileImageTapped = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayoutConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let profileFrame = profileImageView.convert(profileImageView.bounds, to: self)
        
        isProfileImageTapped = profileFrame.contains(touchLocation)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        prepareTouchEvent(.unknown, touches: touches, event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let profileFrame = profileImageView.convert(profileImageView.bounds, to: self)
        
        if isProfileImageTapped, profileFrame.contains(touchLocation) {
            prepareTouchEvent(.profileImageTapped, touches: touches, event: event)
        } else {
            prepareTouchEvent(.unknown, touches: touches, event: event)
        }
        
        isProfileImageTapped = false
    }
    
    func configure(followingCount: Int, followerCount: Int, postCount: Int) {
        guard let followInfoStackView = followInfoStackView.arrangedSubviews as? [FollowInfoView] else { return }
        
        followInfoStackView[0].configure(type: "팔로잉", number: followingCount)
        followInfoStackView[1].configure(type: "팔로워", number: followerCount)
        followInfoStackView[2].configure(type: "작성한 글", number: postCount)
    }
    
    override func configure() {
        badgeLabels.forEach { $0.isHidden = true }
    }
}

// MARK: - Private Methods

private extension MyPageProfileView {
    func setupViews() {
        addSubview(containerView)
        [profileImageView, innerStackView].forEach { containerView.addSubview($0) }
        [userInfoStackView, followInfoStackView].forEach { innerStackView.addArrangedSubview($0) }
        [usernameLabel].forEach { userInfoStackView.addArrangedSubview($0) }
        badgeLabels.forEach { userInfoStackView.addArrangedSubview($0) }
        [
            FollowInfoView(type: "팔로잉", number: 0),
            FollowInfoView(type: "팔로워", number: 0),
            FollowInfoView(type: "작성한 글", number: 0)
        ].forEach { followInfoStackView.addArrangedSubview($0) }
    }
    
    func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
                .inset(LayoutConstants.containerVerticalPadding)
            $0.leading.trailing.equalToSuperview()
                .inset(LayoutConstants.containerHorizontalPadding)
        }
        
        for badgeLabel in badgeLabels {
            badgeLabel.snp.makeConstraints {
                $0.height.equalTo(LayoutConstants.badgeIntrinsicContentSize)
            }
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(LayoutConstants.profileImageViewSize)
        }
        
        innerStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(LayoutConstants.innerStackViewLeadingInset)
            $0.trailing.centerY.height.equalToSuperview()
        }
    }
    
    func prepareTouchEvent(_ type: ResponderEventType, touches: Set<UITouch>, event: UIEvent?) {
        next?.touchesEnded(touches, with: CustomEventWrapper(event: event, type: type))
    }
}

// MARK: - Constants

private extension MyPageProfileView {
    enum LayoutConstants {
        static let containerVerticalPadding: CGFloat = 12
        static let containerHorizontalPadding: CGFloat = 16
        static let profileImageCornerRadius: CGFloat = 40
        static let innerStackViewSpacing: CGFloat = 8
        static let userInfoStackViewSpacing: CGFloat = 10
        static let followInfoStackViewSpacing: CGFloat = 20
        static let profileImageViewSize: CGFloat = 80
        static let innerStackViewLeadingInset: CGFloat = 16
        static let badgeIntrinsicContentSize: CGFloat = 20
        static let badgeCornerRadius: CGFloat = 4
    }
}
