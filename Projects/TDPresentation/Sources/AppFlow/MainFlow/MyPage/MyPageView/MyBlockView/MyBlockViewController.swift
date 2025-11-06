import Combine
import TDDesign
import TDDomain
import UIKit

final class MyBlockViewController: BaseViewController<MyBlockView> {
    weak var coordinator: MyBlockCoordinator?
    private let viewModel: MyBlockViewModel!
    private let input = PassthroughSubject<MyBlockViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private var datasource: UICollectionViewDiffableDataSource<Int, User.ID>?

    init(viewModel: MyBlockViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchBlockedUsers)
    }

    override func configure() {
        setupDataSource()
        layoutView.backgroundColor = TDColor.baseWhite
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "차단 관리",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .fetchBlockedUsers:
                    applySnapshot() // 데이터가 로드되면 스냅샷 갱신
                case .failure(let msg):
                    showErrorAlert(errorMessage: msg)
                }
            }
            .store(in: &cancellables)
    }
}

extension MyBlockViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let width = collectionView.bounds.width - horizontalInsets
        return CGSize(width: width, height: 64)
    }

    private func setupDataSource() {
        datasource = UICollectionViewDiffableDataSource<Int, User.ID>(
            collectionView: layoutView.blockTableView
        ) { [weak self] collectionView, indexPath, userId in
            guard
                let self,
                let user = viewModel.blockedUsers.first(where: { $0.id == userId })
            else { return UICollectionViewCell() }

            let cell: MyBlockCell = collectionView.dequeueReusableCell(for: indexPath)

            let blocked = viewModel.isBlockedState[userId] ?? true
            cell.configure(
                avatarURL: user.icon,
                nickname: user.name,
                isBlocked: blocked
            )
            cell.blockButton.removeTarget(nil, action: nil, for: .allEvents)

            cell.blockButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    let newBlocked = !(viewModel.isBlockedState[userId] ?? true)
                    viewModel.isBlockedState[userId] = newBlocked
                    input.send(newBlocked
                        ? .blockUser(userId: userId)
                        : .unblockUser(userId: userId))

                    if var snapshot = datasource?.snapshot() {
                        snapshot.reloadItems([userId])
                        datasource?.apply(snapshot, animatingDifferences: false)
                    }
                },
                for: .touchUpInside
            )


            return cell
        }

        layoutView.blockTableView.delegate = self
    }

    private func applySnapshot() {
        guard let ds = datasource else { return }
        var snap = NSDiffableDataSourceSnapshot<Int, User.ID>()
        snap.appendSections([0])
        let ids = viewModel.blockedUsers.map(\.id)
        snap.appendItems(ids, toSection: 0)
        ds.apply(snap, animatingDifferences: true)

        if ids.isEmpty {
            layoutView.showEmptyView()
        }
    }
}
