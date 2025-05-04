import Combine
import TDDesign
import TDDomain
import UIKit

final class MyPostViewController: BaseViewController<MyPostView> {
    weak var coordinator: MyPostCoordinator?
    private let viewModel: MyPostViewModel!
    private let input = PassthroughSubject<MyPostViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private var datasource: UICollectionViewDiffableDataSource<Int, Post.ID>?
    
    init(viewModel: MyPostViewModel) {
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
    }
    
    override func configure() {
        setupDataSource()
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.backgroundColor = TDColor.baseWhite
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "작성 글 관리",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
            
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchPosts:
                    applySnapshot(viewModel.posts)
                case .failure(let errorDescription):
                    showErrorAlert(errorMessage: errorDescription)
                case .fetchUser(let userDetail):
                    layoutView.configurePostCountLabel(count: userDetail.totalPostCount)
                }
            }
            .store(in: &cancellables)
    }
}

extension MyPostViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, postID in
            guard let post = self.viewModel.posts.first(where: { $0.id == postID }) else { return UICollectionViewCell() }
            let cell: MyPostCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: post)

            return cell
        })
    }
    
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(posts.map(\.id))
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == layoutView.socialFeedCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            input.send(.loadMorePosts)
        }
    }
}
