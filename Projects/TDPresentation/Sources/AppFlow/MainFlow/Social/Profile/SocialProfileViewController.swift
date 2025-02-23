import Combine
import TDDomain
import UIKit

final class SocialProfileViewController: BaseViewController<SocialProfileView> {
    weak var coordinator: SocialProfileCoordinator?
    private let viewModel: SocialProfileViewModel!
    private let input = PassthroughSubject<SocialProfileViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var datasource: UICollectionViewDiffableDataSource<Int, Post.ID>?
    
    init(viewModel: SocialProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchUser)
        input.send(.fetchUserDetail)
        input.send(.fetchRoutine)
    }
    
    override func configure() {
        setupDataSource()
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchRoutine:
                    self?.layoutView.showRoutineList()
                case .fetchPosts:
                    self?.layoutView.showPostList()
                    self?.applySnapshot(self?.viewModel.posts ?? [])
                case .fetchUser:
                    let url = self?.viewModel.user?.icon ?? ""
                    let badge = self?.viewModel.user?.title ?? ""
                    let nickname = self?.viewModel.user?.name ?? ""
                    self?.layoutView.configure(
                        avatarURL: url,
                        badgeTitle: badge,
                        nickname: nickname
                    )
                case .fetchUserDetail:
                    let followingCount = self?.viewModel.userDetail?.followingCount ?? 0
                    let followerCount = self?.viewModel.userDetail?.followerCount ?? 0
                    let postCount = self?.viewModel.userDetail?.totalPostCount ?? 0
                    let isFollowing = self?.viewModel.userDetail?.isFollowing ?? false
                    self?.layoutView.configureFollowingButton(isFollowing: isFollowing)
                    self?.layoutView.configure(
                        followingCount: followingCount,
                        followerCount: followerCount,
                        postCount: postCount
                    )
                case .failure(let errorDescription):
                    // TODO: Error Alert
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Input

private extension SocialProfileViewController {
    @objc func didTapSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            input.send(.fetchRoutine)
        case 1:
            input.send(.fetchPosts)
        default:
            break
        }
    }
}

// MARK: UICollectionViewDelegate

extension SocialProfileViewController: UICollectionViewDelegate {
    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, postID in
            guard let post = self.viewModel.posts.first(where: { $0.id == postID }) else { return UICollectionViewCell() }
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: post)
            
            return cell
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postId = viewModel.posts[indexPath.item].id
        // TODO: Detail View
        coordinator?.didTapPost(id: postId)
    }
}

// MARK: Collection View Datastore Apply

extension SocialProfileViewController {
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts.map(\.id))
        datasource?.apply(snapshot, animatingDifferences: false)
    }
}
