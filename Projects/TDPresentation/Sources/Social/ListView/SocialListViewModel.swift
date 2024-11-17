import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialListViewModel: BaseViewModel {
    private(set) var posts: [Post] = []
    private(set) var chips: [TDChipItem] = [
        "집중력",
        "기억력",
        "충돌",
        "불안",
        "수면",
        "일반"
    ].map { TDChipItem(title: $0) }
    
    private(set) var fetchState = PassthroughSubject<FetchState, Never>()
    private(set) var refreshState = PassthroughSubject<RefreshState, Never>()
    private(set) var likeState = PassthroughSubject<LikeState, Never>()
    
    private var currentCategory: PostCategory = .all
    private var currentSegment: Int = 0
    private var currentChip: TDChipItem?
    private var currentSort: SocialSortType = .recent
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
        case .refreshPosts:
            refreshPosts()
        case .likePost(let index):
            likePost(at: index)
        case .sortPost(let option):
            sortPost(by: option)
        case .chipSelect(let index):
            selectChips(at: index)
        case .segmentSelect(let index):
            currentSegment = index
            fetchPosts()
        }
    }
}

extension SocialListViewModel {
    private func fetchPosts() {
        Task {
            do {
                let category = currentSegment == 0 ? .all : currentCategory
                fetchState.send(.loading)
                guard let items = try await fetchPostUseCase.execute(type: .communication, category: category) else { return }
                posts = items
                posts.isEmpty ? fetchState.send(.empty) : fetchState.send(.finish(post: posts))
            } catch {
                posts = []
                fetchState.send(.error)
            }
        }
    }
    
    private func refreshPosts() {
        Task {
            do {
                let category = currentSegment == 0 ? .all : currentCategory
                guard let items = try await fetchPostUseCase.execute(type: .communication, category: category) else { return }
                posts = items
                posts.isEmpty ? refreshState.send(.empty) : refreshState.send(.finish(post: posts))
            } catch {
                posts = []
                refreshState.send(.error)
            }
        }
    }
    
    private func likePost(at index: Int) {
        Task {
            do {
                let result = try await togglePostLikeUseCase.execute(post: posts[index])
                guard let likeCount = posts[index].likeCount else { return }
                posts[index].isLike.toggle()
                posts[index].likeCount = posts[index].isLike ? likeCount + 1 : likeCount - 1
                
                likeState.send(.finish(post: posts[index]))
            } catch {
                likeState.send(.error)
            }
        }
    }
    
    private func sortPost(by option: SocialSortType) {
        switch option {
        case .recent:
            posts.sort { $0.timestamp > $1.timestamp }
        case .comment:
            posts.sort { $0.commentCount ?? 0 > $1.commentCount ?? 0 }
        case .sympathy:
            posts.sort { $0.likeCount ?? 0 > $1.likeCount ?? 0 }
        }
        fetchState.send(.finish(post: posts))
    }
    
    private func selectChips(at index: Int) {
        currentCategory = PostCategory(rawValue: chips[index].title) ?? .all
        fetchPosts()
    }
}
