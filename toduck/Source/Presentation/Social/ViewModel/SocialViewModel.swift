import Combine
import UIKit

final class SocialViewModel: BaseViewModel {
    private var posts: [Post] = []
    
    private(set) var fetchState = PassthroughSubject<FetchState, Never>()
    private(set) var likeState = PassthroughSubject<LikeState, Never>()
    
    var count: Int {
        posts.count
    }
    private let fetchPostUseCase: FetchPostUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    
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
}

extension SocialViewModel {
    private func fetchPosts() {
        Task {
            do {
                fetchState.send(.loading)
                guard let items = try await fetchPostUseCase.execute(type: .communication, category: .all) else { return }
                posts = items
                posts.isEmpty ? fetchState.send(.empty) : fetchState.send(.finish(post: posts))
            } catch {
                posts = []
                fetchState.send(.error)
            }
        }
    }
    
    private func likePost(at index: Int) {
        Task {
            do {
                posts[index].isLike = try await togglePostLikeUseCase.execute(post: posts[index])
                likeState.send(.finish(post: posts[index]))
            } catch {
                likeState.send(.error)
            }
        }
    }
}

extension SocialViewModel {
   
}
