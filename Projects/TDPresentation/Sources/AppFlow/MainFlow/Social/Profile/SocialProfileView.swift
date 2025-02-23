import SnapKit
import TDDesign
import TDDomain
import UIKit

final class SocialProfileView: BaseView {
    private let avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 45
        $0.clipsToBounds = true
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    private let nickNameLabel = TDLabel(toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)
    
    private let titleBagde = TDBadge(badgeTitle: "", backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary500)
    
    private let followingLabel = TDLabel(labelText: "팔로잉", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    
    private let followingCountLabel = TDLabel(toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral800)
    
    private let followerLabel = TDLabel(labelText: "팔로워", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    
    private let followerCountLabel = TDLabel(toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral800)
    
    private let whiteBackgroundView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private(set) var followButton = TDButton(
        title: "팔로우",
        size: .small,
        foregroundColor: TDColor.baseWhite,
        backgroundColor: TDColor.Primary.primary500
    ).then {
        $0.layer.cornerRadius = 12
    }
    
    private(set) var segmentedControl = TDSegmentedControl(
        items: ["루틴", "작성한 글"]
    ).then {
        $0.indicatorForeGroundColor = TDColor.Primary.primary500
        $0.selectedSegmentTextColor = TDColor.Primary.primary500
    }
    
    // TODO: Routine View 붙이기
    private(set) lazy var routineView = UIView()
    
    private(set) lazy var socialFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    override func addview() {
        addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(avatarView)
        whiteBackgroundView.addSubview(followButton)
        whiteBackgroundView.addSubview(nickNameLabel)
        whiteBackgroundView.addSubview(titleBagde)
        whiteBackgroundView.addSubview(followButton)
        whiteBackgroundView.addSubview(followingLabel)
        whiteBackgroundView.addSubview(followingCountLabel)
        whiteBackgroundView.addSubview(followerLabel)
        whiteBackgroundView.addSubview(followerCountLabel)
        whiteBackgroundView.addSubview(segmentedControl)
        whiteBackgroundView.addSubview(routineView)
        whiteBackgroundView.addSubview(socialFeedCollectionView)
    }

    override func layout() {
        whiteBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        avatarView.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.top.equalToSuperview().offset(-45)
            make.leading.equalToSuperview().offset(20)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.leading.equalTo(avatarView.snp.leading)
        }
        
        titleBagde.snp.makeConstraints { make in
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(nickNameLabel)
        }
        
        followingLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.leading)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(8)
        }
        
        followingCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(followingLabel.snp.trailing).offset(4)
            make.centerY.equalTo(followingLabel)
        }
        
        followerLabel.snp.makeConstraints { make in
            make.leading.equalTo(followingCountLabel.snp.trailing).offset(20)
            make.centerY.equalTo(followingLabel)
        }
        
        followerCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(followerLabel.snp.trailing).offset(4)
            make.centerY.equalTo(followingLabel)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(120)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(followButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        routineView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral100
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
    }
    
    public func configureFollowingButton(isFollowing: Bool) {
        followButton.setTitle(isFollowing ? "팔로잉" : "팔로우", for: .normal)
        followButton.backgroundColor = isFollowing ? TDColor.Neutral.neutral200 : TDColor.Primary.primary500
    }
    
    public func configure(avatarURL: String, badgeTitle: String, nickname: String) {
        titleBagde.setTitle(badgeTitle)
        nickNameLabel.setText(nickname)
        if let avatarURL = URL(string: avatarURL) {
            avatarView.kf.setImage(with: avatarURL)
        } else {
            avatarView.image = TDImage.Profile.medium
        }
    }
    
    public func configure(followingCount: Int, followerCount: Int, postCount: Int) {
        followingCountLabel.setText("\(followingCount)")
        followerCountLabel.setText("\(followerCount)")
    }
    
    public func showPostList() {
        routineView.isHidden = true
        socialFeedCollectionView.isHidden = false
    }
    
    public func showRoutineList() {
        routineView.isHidden = false
        socialFeedCollectionView.isHidden = true
    }
}

private extension SocialProfileView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let groupPadding: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        
        let edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(0),
            bottom: .fixed(itemPadding)
        )
        
        let groupInset = NSDirectionalEdgeInsets(
            top: 0,
            leading: groupPadding,
            bottom: 0,
            trailing: groupPadding
        )
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            itemEdgeSpacing: edgeSpacing,
            groupSize: groupSize,
            groupInset: groupInset
        )
    }
}
