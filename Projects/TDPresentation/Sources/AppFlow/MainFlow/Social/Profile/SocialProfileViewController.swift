import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialProfileViewController: BaseViewController<SocialProfileView>, TDPopupPresentable {
    enum TimelineCellItem: Hashable {
        case allDay(routine: Routine, showTime: Bool)
        case routine(hour: Int, routine: Routine, showTime: Bool)
    }

    weak var coordinator: SocialProfileCoordinator?
    private let viewModel: SocialProfileViewModel!
    private let input = PassthroughSubject<SocialProfileViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var datasource: UICollectionViewDiffableDataSource<Int, Post.ID>?
    private var timelineDataSource: UITableViewDiffableDataSource<Int, TimelineCellItem>?
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
        input.send(.fetchRoutine)
    }

    override func configure() {
        setupDataSource()
        setupRoutineDataSource()
        layoutView.delegate = self
        layoutView.routineTableView.delegate = self
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
                    self?.applyTimelineSnapshot()
                case .fetchPosts:
                    self?.layoutView.showPostList()
                    self?.applySnapshot(self?.viewModel.posts ?? [])
                    if self?.viewModel.posts.isEmpty == true {
                        self?.layoutView.showPrivateUserDetailView()
                        return
                    }
                case .fetchUser:
                    let url = self?.viewModel.user?.icon ?? ""
                    let badge = self?.viewModel.user?.title ?? ""
                    let nickname = self?.viewModel.user?.name ?? ""
                    let followingCount = self?.viewModel.userDetail?.followingCount ?? 0
                    let followerCount = self?.viewModel.userDetail?.followerCount ?? 0
                    let postCount = self?.viewModel.userDetail?.totalPostCount ?? 0
                    let routineCount = self?.viewModel.userDetail?.totalRoutineCount ?? 0
                    let isFollowing = self?.viewModel.userDetail?.isFollowing ?? false
                    self?.layoutView.configure(
                        avatarURL: url,
                        badgeTitle: badge,
                        nickname: nickname
                    )
                    self?.layoutView.configureFollowingButton(isFollowing: isFollowing)
                    self?.layoutView.configure(
                        followingCount: followingCount,
                        followerCount: followerCount,
                        postCount: postCount,
                        routineCount: routineCount
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
    @objc func didTapSegmentedControl(sender: TDSegmentedControl) {
        switch sender.selectedIndex {
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

extension SocialProfileViewController: UICollectionViewDelegate, SocialProfileDelegate, UITableViewDelegate {
    func didTapFollow() {
        input.send(.toggleFollow)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = timelineDataSource?.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .allDay(let routine, _):
            coordinator?.didTapRoutine(routine: routine)
        case .routine(_, let routine, _):
            coordinator?.didTapRoutine(routine: routine)
        }
    }

    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, postID in
            guard let post = self.viewModel.posts.first(where: { $0.id == postID }) else { return UICollectionViewCell() }
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: post)

            return cell
        })
    }

    private func setupRoutineDataSource() {
        timelineDataSource = UITableViewDiffableDataSource<Int, TimelineCellItem>(tableView: layoutView.routineTableView) { tableView, indexPath, item in
            switch item {
            case .allDay(let routine, let showTime):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineRoutineCell.identifier, for: indexPath) as? TimelineRoutineCell else {
                    return UITableViewCell()
                }
                cell.configure(with: -1, routine: routine, showTime: showTime)
                return cell
            case .routine(let hour, let routine, let showTime):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineRoutineCell.identifier, for: indexPath) as? TimelineRoutineCell else {
                    return UITableViewCell()
                }
                cell.configure(with: hour, routine: routine, showTime: showTime)
                return cell
            }
        }
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

    private func applyTimelineSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TimelineCellItem>()
        snapshot.appendSections([0])
        let items = makeTimelineItems()
        snapshot.appendItems(items, toSection: 0)
        timelineDataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func makeTimelineItems() -> [TimelineCellItem] {
        var items: [TimelineCellItem] = []
        let calendar = Calendar.current

        let allDayRoutines = viewModel.routines.filter(\.isAllDay)
        for (index, allDayRoutine) in allDayRoutines.enumerated() {
            let showTime = (index == 0)
            items.append(.allDay(routine: allDayRoutine, showTime: showTime))
        }

        let timedRoutines = viewModel.routines.filter { !$0.isAllDay && $0.time != nil }

        var routineMapping: [Int: [Routine]] = [:]
        for routine in timedRoutines {
            if let time = routine.time {
                let hourComponent = calendar.component(.hour, from: time)
                routineMapping[hourComponent, default: []].append(routine)
            }
        }

        let sortedHours = routineMapping.keys.sorted()
        for hour in sortedHours {
            if let routines = routineMapping[hour] {
                for (index, routine) in routines.enumerated() {
                    let showTime = (index == 0)
                    items.append(.routine(hour: hour, routine: routine, showTime: showTime))
                }
            }
        }

        return items
    }
}
