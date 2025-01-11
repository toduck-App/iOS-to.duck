import Combine
import TDDomain
import UIKit

final class SocialDetailViewController: BaseViewController<SocialDetailView> {
    private enum Section: Hashable, CaseIterable {
        case post
        case comments
    }
    
    private enum Item: Hashable {
        case post(Post.ID)
        case comment(Comment.ID)
    }
    
    weak var coordinator: SocialDetailCoordinator?
    
    private let input = PassthroughSubject<SocialDetailViewModel.Input, Never>()
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    private let viewModel: SocialDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    public init(viewModel: SocialDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchPost)
        input.send(.fetchComments)
    }
    
    override func configure() {
        datasource = .init(collectionView: layoutView.detailCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .post:
                let cell: SocialDetailPostCell = collectionView.dequeueReusableCell(for: indexPath)
                if let post = self.viewModel.post {
                    cell.configure(with: post)
                    return cell
                }
                return cell
            case .comment(let id):
                let cell: SocialDetailCommentCell = collectionView.dequeueReusableCell(for: indexPath)
                if let comment = self.viewModel.comments.first(where: { $0.id == id }) {
                    cell.configure(with: comment)
                    return cell
                }
            }
            return UICollectionViewCell()
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.post, .comments])
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .post(let post):
                    self?.applySnapshot(items: [.post(post.id)], to: .post)
                case .comments(let comments):
                    let items = comments.map { Item.comment($0.id) }
                    self?.applySnapshot(items: items, to: .comments)
                default:
                    break
                }
            }.store(in: &cancellables)
    }
}

// MARK: Iternal Method

extension SocialDetailViewController {
    private func applySnapshot(items: [Item], to section: Section) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
