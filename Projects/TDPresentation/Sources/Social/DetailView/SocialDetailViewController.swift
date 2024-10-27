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
    
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    private let viewModel: SocialDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        self.viewModel = nil
        super.init()
    }
    
    public init(viewModel: SocialDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.fetchPost)
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
    }
    
    override func binding() {
        viewModel.$post
            .sink { [weak self] post in
                guard let self = self, let post = post else { return }
                self.applySnapshot(items: [.post(post.id)], to: .post)
            }
            .store(in: &cancellables)
        
        viewModel.$comments
            .sink { [weak self] comments in
                guard let self = self else { return }
                let items = comments.map { Item.comment($0.id) }
                self.applySnapshot(items: items, to: .comments)
                
            }
            .store(in: &cancellables)
    }
}

// MARK: Iternal Method
extension SocialDetailViewController {
    private func applySnapshot(items: [Item], to section: Section) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
//    private func updateSnapshot(item: Item, to section: Section) {
//        var snapshot = datasource.snapshot()
//        snapshot.reloadItems([item])
//        datasource.apply(snapshot, animatingDifferences: true)
//    }
}
