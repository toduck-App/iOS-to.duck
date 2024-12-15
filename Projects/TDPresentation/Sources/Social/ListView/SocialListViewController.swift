import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialListViewController: BaseViewController<SocialListView>, TDPopupPresentable {
    weak var coordinator: SocialListCoordinator?
    private let viewModel: SocialListViewModel!
    private let input = PassthroughSubject<SocialListViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var datasource: UICollectionViewDiffableDataSource<Int, Post.ID>?
    
    init(viewModel: SocialListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.send(.fetchPosts)
        setupNavigationBar(style: .social, navigationDelegate: coordinator!)
    }
    
    override func configure() {
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.socialFeedCollectionView.refreshControl = layoutView.refreshControl
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(viewModel.chips)
        setupDataSource()
        layoutView.dropDownHoverView.delegate = self
        layoutView.addPostButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        layoutView.refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        layoutView.segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .fetchPosts:
                    self?.layoutView.showFinishView()
                    self?.applySnapshot(self?.viewModel.posts ?? [])
                case .likePost(let post):
                    self?.updateSnapshot(post)
                case .failure(let message):
                    // TODO: Error Alert
                    self?.layoutView.showErrorView()
                }
            }.store(in: &cancellables)
    }
}

extension SocialListViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        input.send(.chipSelect(at: index))
    }
}

extension SocialListViewController: UICollectionViewDelegate {
    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, postID in
            guard let post = self.viewModel.posts.first(where: { $0.id == postID }) else { return UICollectionViewCell() }
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.socialFeedCellDelegate = self
            cell.configure(with: post)
            
            return cell
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postId = viewModel.posts[indexPath.item].id
        coordinator?.didTapPost(id: postId)
    }
}

// MARK: Input

extension SocialListViewController: SocialFeedCollectionViewCellDelegate, TDDropDownDelegate {
    func didTapBlock(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.socialFeedCollectionView.indexPath(for: cell) else {
            return
        }
        let controller = SocialBlockViewController()
        controller.onBlock = { [weak self] in
            guard let user = self?.viewModel.posts[indexPath.item].user else { return }
            self?.input.send(.blockUser(to: user))
        }
        presentPopup(with: controller)
    }
    
    func didTapReport(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.socialFeedCollectionView.indexPath(for: cell) else {
            return
        }
        coordinator?.didTapReport(id: viewModel.posts[indexPath.item].id)
    }
    
    func didTapRoutineView(_ cell: SocialFeedCollectionViewCell) {
        // TODO: Routine 공유 View
    }
    
    func didTapNicknameLabel(_ cell: SocialFeedCollectionViewCell) {
        // TODO: 프로필 view로 이동
    }
    
    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.socialFeedCollectionView.indexPath(for: cell) else {
            return
        }
        input.send(.likePost(at: indexPath.item))
    }
    
    @objc func didTapSegmentedControl(sender: UISegmentedControl) {
        input.send(.segmentSelect(at: sender.selectedSegmentIndex))
        layoutView.updateLayoutForSegmentedControl(index: sender.selectedSegmentIndex)
    }
    
    @objc func didRefresh() {
        input.send(.refreshPosts)
    }
    
    @objc func didTapCreateButton() {
        coordinator?.didTapCreateButton()
    }
    
    func dropDown(_ dropDownView: TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let option = SocialSortType.allCases[indexPath.row]
        layoutView.dropDownAnchorView.setTitle(option.rawValue)
        input.send(.sortPost(by: option))
    }
}

// MARK: Collection View Datasource Apply

extension SocialListViewController {
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts.map(\.id))
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(_ post: Post) {
        var snapshot = datasource?.snapshot()
        snapshot?.reloadItems([post.id])
        datasource?.apply(snapshot!, animatingDifferences: false)
    }
}
