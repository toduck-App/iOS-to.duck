import Combine
import TDDomain
import UIKit

final class MyCommentViewController: BaseViewController<MyCommentView> {
    weak var coordinator: MyCommentCoordinator?
    private let viewModel: MyCommentViewModel!
    private let input = PassthroughSubject<MyCommentViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private var datasource: UICollectionViewDiffableDataSource<Int, Comment.ID>?
    
    init(viewModel: MyCommentViewModel) {
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
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "나의 댓글",
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
                case .fetchComments:
                    applySnapshot(viewModel.comments)
                case .fetchUser(let userDetail):
                    layoutView.configureCommentCountLabel(count: userDetail.totalCommentCount)
                case .failure(let errorDescription):
                    showErrorAlert(errorMessage: errorDescription)
                }
            }
            .store(in: &cancellables)
    }
}

extension MyCommentViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, commentID in
            guard let comment = self.viewModel.comments.first(where: { $0.id == commentID }) else { return UICollectionViewCell() }
            let cell: MyCommentCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: comment)

            return cell
        })
    }
    
    private func applySnapshot(_ comments: [Comment]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Comment.ID>()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(comments.map(\.id))
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == layoutView.socialFeedCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            input.send(.loadMoreComments)
        }
    }
}
