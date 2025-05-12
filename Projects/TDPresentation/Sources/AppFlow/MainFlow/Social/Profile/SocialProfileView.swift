import SnapKit
import TDDesign
import TDDomain
import UIKit

protocol SocialProfileDelegate: AnyObject {
    func didTapFollow()
}

final class SocialProfileView: BaseView {
    weak var delegate: SocialProfileDelegate?
    
    private let avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 45
        $0.clipsToBounds = true
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.baseWhite.cgColor
    }
    
    private let profileBackgroundView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.image = TDImage.Profile.background1
    }
    
    private let nickNameLabel = TDLabel(toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)
    
    private let titleBagde = TDBadge(badgeTitle: "", backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary500)
    
    private let followingLabel = TDLabel(labelText: "팔로잉", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    
    private let followingCountLabel = TDLabel(toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral800)
    
    private let followerLabel = TDLabel(labelText: "팔로워", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
    
    private let followerCountLabel = TDLabel(toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral800)
    
    private let privateUserDetailView = HideUserView()
    
    private let whiteBackgroundView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private(set) lazy var followButton = TDBaseButton(
        title: "팔로우",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldBody1.font,
        radius: 12
    ).then {
        $0.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapFollow()
        }, for: .touchUpInside)
    }
    
    private(set) var segmentedControl = TDSegmentedControl(
        items: ["루틴", "작성한 글"],
        indicatorForeGroundColor: TDColor.Primary.primary500,
        selectedTextColor: TDColor.Primary.primary500
    )
    
    private let routineLabel = TDLabel(labelText: "루틴 공유수", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.isHidden = true
    }
    
    private let routineCountLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500).then {
        $0.isHidden = true
    }
    
    private let postLabel = TDLabel(labelText: "작성한 글", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800).then {
        $0.isHidden = true
    }
    
    private let postCountLabel = TDLabel(toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500).then {
        $0.isHidden = true
    }
    
    private(set) lazy var routineTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = TDColor.baseWhite
        $0.register(TimelineRoutineCell.self, forCellReuseIdentifier: TimelineRoutineCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 75
    }

    private(set) lazy var socialFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    override func addview() {
        addSubview(profileBackgroundView)
        addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubview(avatarView)
        whiteBackgroundView.addSubview(followButton)
        whiteBackgroundView.addSubview(nickNameLabel)
        whiteBackgroundView.addSubview(titleBagde)
        whiteBackgroundView.addSubview(followingLabel)
        whiteBackgroundView.addSubview(followingCountLabel)
        whiteBackgroundView.addSubview(followerLabel)
        whiteBackgroundView.addSubview(followerCountLabel)
        whiteBackgroundView.addSubview(segmentedControl)
        whiteBackgroundView.addSubview(routineLabel)
        whiteBackgroundView.addSubview(routineCountLabel)
        whiteBackgroundView.addSubview(postLabel)
        whiteBackgroundView.addSubview(postCountLabel)
        whiteBackgroundView.addSubview(routineTableView)
        whiteBackgroundView.addSubview(socialFeedCollectionView)
        whiteBackgroundView.addSubview(privateUserDetailView)
    }

    override func layout() {
        profileBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(avatarView.snp.bottom).offset(20)
        }
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
            make.height.equalTo(44)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(followButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        routineLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        routineCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(routineLabel.snp.trailing).offset(4)
            make.centerY.equalTo(routineLabel)
        }
        
        postLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        postCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(postLabel.snp.trailing).offset(4)
            make.centerY.equalTo(postLabel)
        }
        
        routineTableView.snp.makeConstraints { make in
            make.top.equalTo(routineLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(routineLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        privateUserDetailView.snp.makeConstraints { make in
            make.top.equalTo(routineLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral100
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
    }
    
    public func configureFollowingButton(isFollowing: Bool, isMe: Bool) {
//        profileBackgroundView.image = isFollowing ? TDImage.Profile.background2 : TDImage.Profile.background1
        if isMe {
            followButton.isHidden = true
            return
        }
        followButton.setTitle(isFollowing ? "팔로잉" : "팔로우", for: .normal)
        followButton.configuration?.baseForegroundColor = isFollowing ? TDColor.Neutral.neutral600 : TDColor.baseWhite
        followButton.configuration?.baseBackgroundColor = isFollowing ? TDColor.Neutral.neutral100 : TDColor.Primary.primary500
    }
    
    public func configure(avatarURL: String?, badgeTitle: String, nickname: String) {
        titleBagde.setTitle(badgeTitle)
        nickNameLabel.setText(nickname)
        if let avatarURL, let avatarURL = URL(string: avatarURL) {
            avatarView.kf.setImage(with: avatarURL)
        } else {
            avatarView.image = TDImage.Profile.medium
        }
    }
    
    public func showPrivateUserDetailView() {
        privateUserDetailView.isHidden = false
        postLabel.isHidden = true
        postCountLabel.isHidden = true
    }
    
    public func configure(followingCount: Int, followerCount: Int, postCount: Int, routineCount: Int) {
        followingCountLabel.setText("\(followingCount)")
        followerCountLabel.setText("\(followerCount)")
        postCountLabel.setText("\(postCount)개")
        routineCountLabel.setText("\(routineCount)개")
    }
    
    public func showPostList() {
        postLabel.isHidden = false
        postCountLabel.isHidden = false
        routineLabel.isHidden = true
        routineCountLabel.isHidden = true
        routineTableView.isHidden = true
        socialFeedCollectionView.isHidden = false
        privateUserDetailView.isHidden = true
    }
    
    public func showRoutineList() {
        postLabel.isHidden = true
        postCountLabel.isHidden = true
        routineLabel.isHidden = false
        routineCountLabel.isHidden = false
        routineTableView.isHidden = false
        socialFeedCollectionView.isHidden = true
        privateUserDetailView.isHidden = true
    }
}

private extension SocialProfileView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
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
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            itemEdgeSpacing: edgeSpacing,
            groupSize: groupSize
        )
    }
}
