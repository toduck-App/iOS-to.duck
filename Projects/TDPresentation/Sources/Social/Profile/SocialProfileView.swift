import SnapKit
import TDDesign
import TDDomain
import UIKit

final class SocialProfileView: BaseView {
    private let userProfileView = UserProfileView()
    private let userDetailView = UserDetailView()
    
    private(set) var followButton = TDButton(
        title: "팔로우",
        size: .small,
        foregroundColor: TDColor.baseWhite,
        backgroundColor: TDColor.Primary.primary500
    ).then {
        $0.layer.cornerRadius = 8
    }
    
    private(set) var shareButton = TDBaseButton(
        image: TDImage.shareMedium,
        backgroundColor: .clear,
        foregroundColor: TDColor.Neutral.neutral300,
        radius: 8
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    private(set) var segmentedControl = TDSegmentedControl(
        items: ["루틴", "작성한 글"]
    ).then {
        $0.indicatorColor = TDColor.Primary.primary500
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
        addSubview(userProfileView)
        addSubview(userDetailView)
        addSubview(followButton)
        addSubview(shareButton)
        addSubview(segmentedControl)
        addSubview(routineView)
        addSubview(socialFeedCollectionView)
    }

    override func layout() {
        userProfileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.height.equalTo(60)
        }
        
        userDetailView.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(userDetailView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(shareButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(followButton)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(40)
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
        backgroundColor = TDColor.baseWhite
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
    }
    
    public func configure(avatarURL: String, badgeTitle: String, nickname: String) {
        userProfileView.configure(
            userAvatar: avatarURL,
            titleBadge: badgeTitle,
            nickname: nickname,
            description: "토덕님과 비슷한 루틴을 가진 유저에요!"
        )
    }
    
    public func configure(followingCount: Int, followerCount: Int, postCount: Int) {
        userDetailView.configure(
            followingCount: followingCount,
            followerCount: followerCount,
            postCount: postCount
        )
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
