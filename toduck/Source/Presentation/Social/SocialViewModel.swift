import Combine
import UIKit

final class SocialViewModel: BaseViewModel {
    
    enum Action {
        case fetchPosts
    }
    
    enum FetchState {
        case loading
        case finish
        case empty
        case error
    }
    
    private var datasource: UICollectionViewDiffableDataSource<Int, Post>?
    
    private(set) var posts: [Post] = [] {
        didSet {
            applySnapshot(posts)
        }
    }
    private(set) var fetchState = PassthroughSubject<FetchState, Never>()
    let useCase: FetchPostUseCase
    
    init(useCase: FetchPostUseCase) {
        self.useCase = useCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchPosts:
            fetchPosts()
        }
    }
    
    func configureDatasource(_ dataSource: UICollectionViewDiffableDataSource<Int, Post>) {
        datasource = dataSource
    }
    
    func likePost(at index: Int) {
        posts[index].isLike.toggle()
    }
}

extension SocialViewModel {
    private func fetchPosts() {
        Task {
            do {
                fetchState.send(.loading)
                guard let items = try await useCase.execute(type: .communication, category: .all) else { return }
                posts = items
                posts.isEmpty ? fetchState.send(.empty) : fetchState.send(.finish)
            } catch(let error) {
                posts = []
                fetchState.send(.error)
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
}
