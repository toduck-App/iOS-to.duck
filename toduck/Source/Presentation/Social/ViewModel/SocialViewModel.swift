import Combine
import UIKit

final class SocialViewModel: BaseViewModel {
    private var datasource: UICollectionViewDiffableDataSource<Int, Post>?
    
    private(set) var posts: [Post] = [] {
        didSet {
            applySnapshot(posts)
        }
    }
    
    private(set) var fetchState = PassthroughSubject<FetchState, Never>()
    private(set) var likeState = PassthroughSubject<LikeState, Never>()
    
    let fetchPostUseCase: FetchPostUseCase
    let togglePostLikeUseCase: TogglePostLikeUseCase
    
    // MARK: Initializer
    init(fetchPostUseCase: FetchPostUseCase,
         togglePostLikeUseCase: TogglePostLikeUseCase
    ) {
        self.fetchPostUseCase = fetchPostUseCase
        self.togglePostLikeUseCase = togglePostLikeUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchPosts:
            fetchPosts()
        case .likePost(let index):
            likePost(at: index)
        }
    }
    
    func configureDatasource(_ dataSource: UICollectionViewDiffableDataSource<Int, Post>) {
        datasource = dataSource
    }
}

extension SocialViewModel {
    private func fetchPosts() {
        Task {
            do {
                fetchState.send(.loading)
                guard let items = try await fetchPostUseCase.execute(type: .communication, category: .all) else { return }
                posts = items
                posts.isEmpty ? fetchState.send(.empty) : fetchState.send(.finish)
            } catch {
                posts = []
                fetchState.send(.error)
            }
        }
    }
    
    private func likePost(at index: Int) {
        Task {
            do {
                var post = posts[index]
                let isLike = try await togglePostLikeUseCase.execute(post: post)
                post.isLike = isLike
                posts[index] = post
                updateSnapshot(post)
                likeState.send(.finish)
            } catch {
                likeState.send(.error)
            }
        }
    }
}

extension SocialViewModel {
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts)
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateSnapshot(_ post: Post) {
        var snapshot = datasource?.snapshot()
        snapshot?.reloadItems([post])
        datasource?.apply(snapshot!, animatingDifferences: false)
    }
}
