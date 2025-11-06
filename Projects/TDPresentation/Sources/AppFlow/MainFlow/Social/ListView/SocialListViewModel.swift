import Foundation
import Combine
import TDCore
import TDDomain

final class SocialListViewModel: BaseViewModel {
    enum Input {
        case appear
        case refresh
        case sortPost(by: SocialSortType)
        case chipSelect(at: Int)
        case segmentSelect(at: Int)
        case search(term: String)
        case clearSearch
        case loadMore
        case likePost(Post.ID, currentLike: Bool)
        case blockUser(User.ID)
        case deletePost(Post.ID)

        case loadKeywords
        case deleteRecentKeyword(index: Int)
        case deleteRecentAllKeywords
    }

    enum Output {
        case posts([Post])
        case updateKeywords
        case failure(String)
    }

    // MARK: - State (UI 제어용)
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()

    private var currentCategory: PostCategory?
    private var currentSegment: Int = 0
    private var currentSort: SocialSortType = .recent
    private(set) var searchTerm: String = ""
    private var isSearching: Bool { !searchTerm.isEmpty }

    // Paging/UI guard
    private var isLoadingMore = false

    // UseCases
    private let repo: SocialRepository
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let updateRecentKeywordUseCase: UpdateKeywordUseCase
    private let fetchRecentKeywordUseCase: FetchKeywordUseCase
    private let deleteRecentKeywordUseCase: DeleteKeywordUseCase
    private let deletePostUseCase: DeletePostUseCase

    // Keywords
    private(set) var recentKeywords: [Keyword] = []
    private(set) var popularKeywords: [Keyword] = ["루틴","집중","뽀모도로","꿀팁","시간관리","ADHD","일기"]
        .map { Keyword(date: Date(), word: $0) }

    // MARK: - Init
    init(
        repo: SocialRepository,
        togglePostLikeUseCase: TogglePostLikeUseCase,
        blockUserUseCase: BlockUserUseCase,
        updateRecentKeywordUseCase: UpdateKeywordUseCase,
        fetchRecentKeywordUseCase: FetchKeywordUseCase,
        deleteRecentKeywordUseCase: DeleteKeywordUseCase,
        deletePostUseCase: DeletePostUseCase
    ) {
        self.repo = repo
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.blockUserUseCase = blockUserUseCase
        self.updateRecentKeywordUseCase = updateRecentKeywordUseCase
        self.fetchRecentKeywordUseCase = fetchRecentKeywordUseCase
        self.deleteRecentKeywordUseCase = deleteRecentKeywordUseCase
        self.deletePostUseCase = deletePostUseCase

        bindRepository()
    }

    // MARK: - Binding
    private func bindRepository() {
        repo.postPublisher
            .map { [weak self] posts -> [Post] in
                guard let self else { return posts }
                return self.sort(posts, by: self.currentSort)
            }
            .sink { [weak self] sorted in
                self?.output.send(.posts(sorted))
            }
            .store(in: &cancellables)
    }

    // MARK: - Transform
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self else { return }
                Task { await self.handle(event) }
            }
            .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    // MARK: - Event handling
    @MainActor
    private func handle(_ event: Input) async {
        switch event {
        case .appear, .refresh:
            await refresh()

        case .sortPost(let sortType):
            currentSort = sortType
            output.send(.posts(sortedSnapshot()))

        case .chipSelect(let index):
            if 0 <= index, index < PostCategory.allCases.count {
                currentCategory = PostCategory.allCases[index]
            } else {
                currentCategory = nil
            }
            await refresh()

        case .segmentSelect(let index):
            currentSegment = index
            await refresh()

        case .search(let term):
            searchTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
            await search()

        case .clearSearch:
            searchTerm = ""
            repo.setModeDefault()
            output.send(.posts(await repo.currentPosts()))

        case .loadMore:
            guard !isLoadingMore else { return }
            isLoadingMore = true
            defer { isLoadingMore = false }
            do {
                try await repo.loadMore(limit: 20, category: currentCategoryPayload())
            } catch {
                output.send(.failure("추가 게시글을 불러오는데 실패했습니다."))
            }

        case .likePost(let id, let currentLike):
            do {
                try await togglePostLikeUseCase.execute(postID: id, currentLike: currentLike)
            } catch {
                output.send(.failure("게시글 좋아요에 실패했습니다."))
            }

        case .blockUser(let userID):
            do {
                try await blockUserUseCase.execute(userID: userID)
                await refresh()
            } catch {
                output.send(.failure("사용자 차단에 실패했습니다."))
            }

        case .deletePost(let postID):
            do {
                try await deletePostUseCase.execute(postID: postID)
            } catch {
                output.send(.failure("게시글 삭제에 실패했습니다."))
            }

        case .loadKeywords:
            loadKeywords()

        case .deleteRecentKeyword(let index):
            deleteRecentKeyword(index: index)

        case .deleteRecentAllKeywords:
            deleteAllRecentKeywords()
        }
    }

    // MARK: - Actions
    private func currentCategoryPayload() -> [PostCategory]? {
        (currentSegment == 0) ? nil : [currentCategory].compactMap { $0 }
    }

    private func refresh() async {
        do {
            if isSearching {
                try await repo.startSearch(keyword: searchTerm, limit: 20, category: currentCategoryPayload())
            } else {
                try await repo.refresh(limit: 20, category: currentCategoryPayload())
            }
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }

    private func search() async {
        guard !searchTerm.isEmpty else {
            await refresh()
            return
        }
        do {
            try updateRecentKeywordUseCase.execute(keyword: Keyword(date: Date(), word: searchTerm))
            try await repo.startSearch(keyword: searchTerm, limit: 20, category: currentCategoryPayload())
        } catch {
            output.send(.failure("검색 결과를 불러오는데 실패했습니다."))
        }
    }

    // MARK: - Sorting
    private func sort(_ array: [Post], by sortType: SocialSortType) -> [Post] {
        switch sortType {
        case .recent:
            return array.sorted { $0.timestamp > $1.timestamp }
        case .comment:
            return array.sorted { ($0.commentCount ?? 0) > ($1.commentCount ?? 0) }
        case .sympathy:
            return array.sorted { $0.likeCount > $1.likeCount }
        }
    }

    private func sortedSnapshot() -> [Post] {
        var snapshot: [Post] = []
        let sema = DispatchSemaphore(value: 0)
        Task {
            let posts = await repo.currentPosts()
            snapshot = sort(posts, by: currentSort)
            sema.signal()
        }
        sema.wait()
        return snapshot
    }

    // MARK: - Keywords
    private func loadKeywords() {
        recentKeywords = fetchRecentKeywordUseCase.execute()
        output.send(.updateKeywords)
    }

    private func deleteRecentKeyword(index: Int) {
        guard index >= 0, index < recentKeywords.count else { return }
        do {
            try deleteRecentKeywordUseCase.execute(keyword: recentKeywords[index])
            loadKeywords()
        } catch {
            output.send(.failure("최근 검색어 삭제에 실패했습니다."))
        }
    }

    private func deleteAllRecentKeywords() {
        deleteRecentKeywordUseCase.execute()
        loadKeywords()
    }
}
