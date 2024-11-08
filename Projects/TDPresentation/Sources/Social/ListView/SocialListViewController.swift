import Combine
import TDDesign
import TDDomain
import UIKit

class SocialListViewController: BaseViewController<SocialListView> {
    weak var coordinator: SocialListCoordinator?
    private let viewModel: SocialListViewModel!
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
        viewModel.action(.fetchPosts)
    }
    
    override func configure() {
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.socialFeedCollectionView.refreshControl = layoutView.refreshControl
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(viewModel.chips)
        setupDataSource()
        layoutView.dropDownHoverView.delegate = self
        layoutView.refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        layoutView.segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
    }
    
    override func addView() {
        
    }
    
    override func layout() {
        
    }
    
    override func binding() {
        viewModel.fetchState.sink { [weak self] state in
            switch state {
            case .loading:
                self?.layoutView.showLoadingView()
            case .finish(let posts):
                DispatchQueue.main.async {
                    self?.applySnapshot(posts)
                }
                self?.layoutView.showFinishView()
            case .empty:
                self?.layoutView.showEmptyView()
            case .error:
                self?.layoutView.showErrorView()
            }
        }.store(in: &cancellables)
        
        viewModel.refreshState.sink { [weak self] state in
            switch state {
            case .finish(let posts):
                DispatchQueue.main.async {
                    self?.applySnapshot(posts)
                    self?.layoutView.showEndRefreshControl()
                }
            case .empty:
                self?.layoutView.showEmptyView()
            case .error:
                self?.layoutView.showErrorView()
            }
        }.store(in: &cancellables)
        
        viewModel.likeState.sink { [weak self] state in
            switch state {
            case .finish(let post):
                DispatchQueue.main.async {
                    self?.updateSnapshot(post)
                }
            case .error:
                self?.layoutView.showErrorView()
            }
        }.store(in: &cancellables)
    }
}


extension SocialListViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        viewModel.action(.chipSelect(at: index))
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
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postId = viewModel.posts[indexPath.item].id
        coordinator?.didTapPost(id: postId)
    }
}

//MARK: Input
extension SocialListViewController: SocialFeedCollectionViewCellDelegate, TDDropDownDelegate {
    func didTapRoutineView(_ cell: SocialFeedCollectionViewCell) {
        // TODO: Routine 공유 View
    }
    
    func didTapNicknameLabel(_ cell: SocialFeedCollectionViewCell) {
        // TODO: 프로필 view로 이동
    }
    
    func didTapMoreButton(_ cell: SocialFeedCollectionViewCell) {
        // TODO: 신고하기/차단하기 && 내꺼라면 삭제하기
    }
    
    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.socialFeedCollectionView.indexPath(for: cell) else {
            return
        }
        viewModel.action(.likePost(at: indexPath.item))
    }
    
    @objc func didTapSegmentedControl(sender: UISegmentedControl) {
        viewModel.action(.segmentSelect(at: sender.selectedSegmentIndex))
        layoutView.updateLayoutForSegmentedControl(index: sender.selectedSegmentIndex)
    }
    
    @objc func didRefresh() {
        viewModel.action(.refreshPosts)
    }
    
    func dropDown(_ dropDownView: TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let option = SocialSortType.allCases[indexPath.row]
        layoutView.dropDownAnchorView.setTitle(option.rawValue)
        viewModel.action(.sortPost(by: option))
    }
}

// MARK: Collection View Datasource Apply
extension SocialListViewController {
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts.map { $0.id })
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(_ post: Post) {
        var snapshot = datasource?.snapshot()
        snapshot?.reloadItems([post.id])
        datasource?.apply(snapshot!, animatingDifferences: false)
    }
}
