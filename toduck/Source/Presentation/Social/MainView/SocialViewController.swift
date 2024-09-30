import Combine
import UIKit

class SocialViewController: BaseViewController<SocialView>, TDSheetPresentation {
    weak var coordinator: SocialCoordinator?
    private let searchBar = UISearchBar()
    private var filteredPosts: [Post] = []
    private var datasource: UICollectionViewDiffableDataSource<Int, Post>?
    private let viewModel: SocialViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    let chips: [TDChipItem] = [
        TDChipItem(title: "집중력"),
        TDChipItem(title: "기억력"),
        TDChipItem(title: "충돌"),
        TDChipItem(title: "불안"),
        TDChipItem(title: "수면"),
    ]
    
    init(viewModel: SocialViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(chips)
        setupDataSource()
        viewModel.action(.fetchPosts)
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
            case .finish:
                self?.layoutView.showFinishView()
            case .empty:
                self?.layoutView.showEmptyView()
            case .error:
                self?.layoutView.showErrorView()
            }
        }.store(in: &cancellables)
    }
}


extension SocialViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        print("[LOG] 현재 Select 한 Chip: \(chipText) , Index = : \(index)")
        layoutView.hideDropdown()
    }
}

extension SocialViewController: UICollectionViewDelegate {
    
    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
           
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let post = self.viewModel.posts[indexPath.item]
            cell.socialFeedCellDelegate = self
            cell.configure(with: post)
            return cell
        })
        
        guard let datasource else { return }
        viewModel.configureDatasource(datasource)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.moveToSocialDetailController(by: indexPath.item)
    }
}

extension SocialViewController: SocialFeedCollectionViewCellDelegate{
    func didTapNickname(_ cell: SocialFeedCollectionViewCell) {
        
    }

    func didTapMoreButton(_ cell: SocialFeedCollectionViewCell) {
    
    }
    
    func didTapCommentButton(_ cell: SocialFeedCollectionViewCell) {
        print("[LOG] Comment Button Clicked")
    }

    func didTapShareButton(_ cell: SocialFeedCollectionViewCell) {
        print("[LOG] Share Button Clicked")
    }

    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell) {
        print("[LOG] Like Button Clicked")
        guard let indexPath = layoutView.socialFeedCollectionView.indexPath(for: cell) else {
            return
        }
        viewModel.action(.likePost(at: indexPath.item))
    }
}
