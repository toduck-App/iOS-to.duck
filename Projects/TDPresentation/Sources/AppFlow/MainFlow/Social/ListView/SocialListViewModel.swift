import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialListViewModel: BaseViewModel {
    enum Input {
        case fetchPosts
        case refreshPosts
        case likePost(Post.ID)
        case sortPost(by: SocialSortType)
        case chipSelect(at: Int)
        case segmentSelect(at: Int)
        case blockUser(to: User.ID)
        case loadKeywords
        case deleteRecentKeyword(index: Int)
        case deleteRecentAllKeywords
        case search(term: String)
        case clearSearch
        case loadMorePosts
        case deletePost(Post.ID)
    }

    enum Output {
        case fetchPosts([Post])
        case searchPosts([Post])
        case likePost(Post)
        case updateKeywords
        case failure(String)
    }

    // MARK: - Properties

    // 선택 상태
    private var isLoadingMore: Bool = false
    private var currentCategory: PostCategory?
    private var currentSegment: Int = 0 // 0이 전체, 1이 주제별
    private var currentChip: TDChipItem?
    private var currentSort: SocialSortType = .recent
    private var searchTerm: String = ""
    private var isSearching: Bool { !searchTerm.isEmpty }

    var posts: [Post] { isSearching ? searchPosts : defaultPosts }

    private var defaultPosts: [Post] = []
    private var searchPosts: [Post] = []

    // Cursor
    private var fetchCursor = SocialCursor()
    private var searchCursor = SocialCursor()

    // 검색어 히스토리
    private(set) var recentKeywords: [Keyword] = []
    private(set) var popularKeywords: [Keyword] = ["루틴", "집중", "뽀모도로", "꿀팁", "시간관리", "ADHD", "일기"].map { Keyword(date: Date(), word: $0) }

    // UseCase
    private let fetchPostUseCase: FetchPostUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let searchPostUseCase: SearchPostUseCase
    private let updateRecentKeywordUseCase: UpdateKeywordUseCase
    private let fetchRecentKeywordUseCase: FetchKeywordUseCase
    private let deleteRecentKeywordUseCase: DeleteKeywordUseCase
    private let deletePostUseCase: DeletePostUseCase

    // Combine
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()

    // MARK: - Initializer

    init(
        fetchPostUseCase: FetchPostUseCase,
        togglePostLikeUseCase: TogglePostLikeUseCase,
        blockUserUseCase: BlockUserUseCase,
        searchPostUseCase: SearchPostUseCase,
        updateRecentKeywordUseCase: UpdateKeywordUseCase,
        fetchRecentKeywordUseCase: FetchKeywordUseCase,
        deleteRecentKeywordUseCase: DeleteKeywordUseCase,
        deletePostUseCase: DeletePostUseCase
    ) {
        self.fetchPostUseCase = fetchPostUseCase
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.blockUserUseCase = blockUserUseCase
        self.searchPostUseCase = searchPostUseCase
        self.updateRecentKeywordUseCase = updateRecentKeywordUseCase
        self.fetchRecentKeywordUseCase = fetchRecentKeywordUseCase
        self.deleteRecentKeywordUseCase = deleteRecentKeywordUseCase
        self.deletePostUseCase = deletePostUseCase
    }

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchPosts, .refreshPosts:
                    Task { await self.loadPosts() }
                case .likePost(let postID):
                    Task { await self.likePost(postID: postID) }
                case .sortPost(let sortType):
                    currentSort = sortType
                    sortCurrentPosts()
                case .chipSelect(let index):
                    selectChips(at: index)
                case .segmentSelect(let index):
                    currentSegment = index
                    Task { await self.loadPosts() }
                case .blockUser(let userID):
                    Task { await self.blockUser(to: userID) }
                case .loadKeywords:
                    loadKeywords()
                case .deleteRecentKeyword(let index):
                    deleteRecentKeyword(index: index)
                case .deleteRecentAllKeywords:
                    deleteAllRecentKeywords()
                case .search(let term):
                    searchTerm = term
                    Task { await self.loadPosts() }
                case .clearSearch:
                    searchTerm = ""
                    Task { await self.loadPosts() }
                case .loadMorePosts:
                    guard !isLoadingMore else { return }
                    isLoadingMore = true
                    Task {
                        await self.loadMorePosts()
                        self.isLoadingMore = false
                    }
                case .deletePost(let postID):
                    Task { await self.deletePost(postId: postID) }
                }
            }
            .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

extension SocialListViewModel {
    private func loadPosts() async {
        let currentCategories: [PostCategory] = [currentCategory].compactMap { $0 }
        let category: [PostCategory]? = (currentSegment == 0) ? nil : currentCategories

        do {
            if isSearching {
                saveKeywords(term: searchTerm)
                searchCursor.reset()

                let results = try await searchPostUseCase.execute(
                    keyword: searchTerm,
                    cursor: searchCursor.nextCursor,
                    limit: 20,
                    category: category
                )
                searchCursor.update(with: (hasMore: results.hasMore, nextCursor: results.nextCursor))
                searchPosts = sortPosts(array: results.result, by: currentSort)
                output.send(.searchPosts(searchPosts))
            } else {
                fetchCursor.reset()

                let results = try await fetchPostUseCase.execute(
                    cursor: fetchCursor.nextCursor,
                    limit: 20,
                    category: category
                )
                fetchCursor.update(with: (hasMore: results.hasMore, nextCursor: results.nextCursor))
                defaultPosts = sortPosts(array: results.result, by: currentSort)
                output.send(.fetchPosts(defaultPosts))
            }
        } catch {
            if isSearching {
                searchPosts.removeAll()
            } else {
                defaultPosts.removeAll()
            }
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }

    private func sortCurrentPosts() {
        if isSearching {
            searchPosts = sortPosts(array: searchPosts, by: currentSort)
            output.send(.searchPosts(searchPosts))
        } else {
            defaultPosts = sortPosts(array: defaultPosts, by: currentSort)
            output.send(.fetchPosts(defaultPosts))
        }
    }

    private func sortPosts(array: [Post], by sortType: SocialSortType) -> [Post] {
        switch sortType {
        case .recent:
            array.sorted { $0.timestamp > $1.timestamp }
        case .comment:
            array.sorted { ($0.commentCount ?? 0) > ($1.commentCount ?? 0) }
        case .sympathy:
            array.sorted { $0.likeCount > $1.likeCount }
        }
    }

    // MARK: - Like

    private func likePost(postID: Post.ID) async {
        do {
            if let defaultIndex = defaultPosts.firstIndex(where: { $0.id == postID }) {
                var resultPost = defaultPosts[defaultIndex]
                try await togglePostLikeUseCase.execute(postID: postID, currentLike: resultPost.isLike)
                resultPost.toggleLike()
                defaultPosts[defaultIndex] = resultPost
                output.send(.likePost(resultPost))
            } else if let searchIndex = searchPosts.firstIndex(where: { $0.id == postID }) {
                var resultPost = searchPosts[searchIndex]
                try await togglePostLikeUseCase.execute(postID: postID, currentLike: resultPost.isLike)
                resultPost.toggleLike()
                searchPosts[searchIndex] = resultPost
                output.send(.likePost(resultPost))
            }
        } catch {
            output.send(.failure("게시글 좋아요에 실패했습니다."))
        }
    }

    // MARK: - Category 설정

    private func selectChips(at index: Int) {
        guard index >= 0, index < PostCategory.allCases.count else { return }
        currentCategory = PostCategory.allCases[index]
        Task { await loadPosts() }
    }

    // MARK: - Block User 차단

    private func blockUser(to userID: User.ID) async {
        do {
            try await blockUserUseCase.execute(userID: userID)
            if isSearching {
                searchPosts.removeAll { $0.user.id == userID }
                output.send(.searchPosts(searchPosts))
            } else {
                defaultPosts.removeAll { $0.user.id == userID }
                output.send(.fetchPosts(defaultPosts))
            }
            // TODO: 차단 기능에 대한 후처리
        } catch {
            output.send(.failure("사용자 차단에 실패했습니다."))
        }
    }

    // MARK: - Keywords

    private func loadKeywords() {
        recentKeywords = fetchRecentKeywordUseCase.execute()
        output.send(.updateKeywords)
    }

    private func deleteRecentKeyword(index: Int) {
        guard index >= 0, index < recentKeywords.count else { return }
        let keyword = recentKeywords[index]
        do {
            try deleteRecentKeywordUseCase.execute(keyword: keyword)
            loadKeywords()
        } catch {
            output.send(.failure("최근 검색어 삭제에 실패했습니다."))
        }
    }

    private func deleteAllRecentKeywords() {
        deleteRecentKeywordUseCase.execute()
        loadKeywords()
    }

    private func saveKeywords(term: String) {
        do {
            try updateRecentKeywordUseCase.execute(keyword: Keyword(date: Date(), word: term))
            loadKeywords()
        } catch {
            output.send(.failure("검색어 저장에 실패했습니다."))
        }
    }

    private func loadMorePosts() async {
        let currentCategories: [PostCategory] = [currentCategory].compactMap { $0 }
        let category: [PostCategory]? = (currentSegment == 0) ? nil : currentCategories

        do {
            if isSearching {
                guard searchCursor.hasMore, let currentCursor = searchCursor.nextCursor else { return }
                let results = try await searchPostUseCase.execute(
                    keyword: searchTerm,
                    cursor: currentCursor,
                    limit: 20,
                    category: category
                )
                searchCursor.update(with: (hasMore: results.hasMore, nextCursor: results.nextCursor))
                let morePosts = sortPosts(array: results.result, by: currentSort)
                searchPosts.append(contentsOf: morePosts)
                output.send(.searchPosts(searchPosts))
            } else {
                guard fetchCursor.hasMore, let currentCursor = fetchCursor.nextCursor else { return }
                let results = try await fetchPostUseCase.execute(
                    cursor: currentCursor,
                    limit: 20,
                    category: category
                )
                fetchCursor.update(with: (hasMore: results.hasMore, nextCursor: results.nextCursor))
                let morePosts = sortPosts(array: results.result, by: currentSort)
                defaultPosts.append(contentsOf: morePosts)
                output.send(.fetchPosts(defaultPosts))
            }
        } catch {
            output.send(.failure("추가 게시글을 불러오는데 실패했습니다."))
        }
    }

    private func deletePost(postId: Post.ID) async {
        do {
            try await deletePostUseCase.execute(postID: postId)
            if isSearching {
                searchPosts.removeAll { $0.id == postId }
                output.send(.searchPosts(searchPosts))
            } else {
                defaultPosts.removeAll { $0.id == postId }
                output.send(.fetchPosts(defaultPosts))
            }

        } catch {
            output.send(.failure("게시글 삭제에 실패했습니다."))
        }
    }
}

public struct SocialCursor {
    public private(set) var nextCursor: Int?
    public private(set) var hasMore: Bool

    public init(nextCursor: Int? = nil, hasMore: Bool = true) {
        self.nextCursor = nextCursor
        self.hasMore = hasMore
    }

    public mutating func update(with result: (hasMore: Bool, nextCursor: Int?)) {
        hasMore = result.hasMore
        nextCursor = result.nextCursor
    }

    public mutating func reset() {
        nextCursor = nil
        hasMore = true
    }
}
