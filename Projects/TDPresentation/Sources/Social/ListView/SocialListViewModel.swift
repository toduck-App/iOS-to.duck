import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialListViewModel: BaseViewModel {
    enum Input {
        case fetchPosts
        case refreshPosts
        case likePost(at: Int)
        case sortPost(by: SocialSortType)
        case chipSelect(at: Int)
        case segmentSelect(at: Int)
    }

    enum Output {
        case fetchPosts
        case likePost(Post)
        case failure(String)
    }

    private(set) var posts: [Post] = []
    private(set) var chips: [TDChipItem] = PostCategory.allCases.map { TDChipItem(title: $0.rawValue) }
    
    private let output = PassthroughSubject<Output, Never>()
    private var currentCategory: PostCategory = .all
    private var currentSegment: Int = 0
    private var currentChip: TDChipItem?
    private var currentSort: SocialSortType = .recent
    private let fetchPostUseCase: FetchPostUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializer
    init(fetchPostUseCase: FetchPostUseCase,
         togglePostLikeUseCase: TogglePostLikeUseCase
    ) {
        self.fetchPostUseCase = fetchPostUseCase
        self.togglePostLikeUseCase = togglePostLikeUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchPosts, .refreshPosts:
                self?.fetchPosts()
            case .likePost(let index):
                self?.likePost(at: index)
            case .sortPost(let option):
                self?.sortPost(by: option)
            case .chipSelect(let index):
                self?.selectChips(at: index)
            case .segmentSelect(let index):
                self?.currentSegment = index
                self?.fetchPosts()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension SocialListViewModel {
    private func fetchPosts() {
        Task {
            do {
                let category = currentSegment == 0 ? .all : currentCategory
                
                guard let items = try await fetchPostUseCase.execute(type: .communication, category: category) else { return }
                posts = items
                output.send(.fetchPosts)
            } catch {
                posts = []
                output.send(.failure("게시글을 불러오는데 실패했습니다."))
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
                output.send(.likePost(posts[index]))
            } catch {
                output.send(.failure("게시글 좋아요를 실패했습니다."))
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
        output.send(.fetchPosts)
    }
    
    private func selectChips(at index: Int) {
        currentCategory = PostCategory(rawValue: chips[index].title) ?? .all
        fetchPosts()
    }
}
