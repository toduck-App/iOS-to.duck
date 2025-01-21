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
        case blockUser(to: User)
        case loadKeywords
        case deleteRecentKeyword(index: Int)
        case deleteRecentAllKeywords
        case search(term: String)
        case clearSearch
    }

    enum Output {
        case fetchPosts([Post])
        case searchPosts([Post])
        case likePost(Post)
        case updateKeywords
        case failure(String)
    }
    
    struct Keyword: Identifiable, Hashable {
        var id = UUID()
        var word: String
    }
    
    // MARK: - Properties
    
    // 선택 상태
    private var currentCategory: PostCategory?
    private var currentSegment: Int = 0 // 0이 전체, 1이 주제별
    private var currentChip: TDChipItem?
    private var currentSort: SocialSortType = .recent
    private var searchTerm: String = ""
    private var isSearching: Bool { !searchTerm.isEmpty }
    
    var posts: [Post] {
        get { isSearching ? searchPosts : defaultPosts }
    }
    private var defaultPosts: [Post] = []
    private var searchPosts: [Post] = []
    
    // 검색어 히스토리
    private(set) var recentKeywords: [Keyword] = ["콘서타", "루틴", "불면증"].map { Keyword(word: $0) }
    private(set) var popularKeywords: [Keyword] = ["루틴", "집중", "뽀모도로", "꿀팁", "시간관리", "ADHD", "일기"].map { Keyword(word: $0) }
    
    // UseCase
    private let fetchPostUseCase: FetchPostUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let searchPostUseCase: SearchPostUseCase

    // Combine
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Initializer
    
    init(
        fetchPostUseCase: FetchPostUseCase,
        togglePostLikeUseCase: TogglePostLikeUseCase,
        blockUserUseCase: BlockUserUseCase,
        searchPostUseCase: SearchPostUseCase
    ) {
        self.fetchPostUseCase = fetchPostUseCase
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.blockUserUseCase = blockUserUseCase
        self.searchPostUseCase = searchPostUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchPosts, .refreshPosts:
                    Task { await self.loadPosts() }
                case .likePost(let index):
                    Task { await self.likePost(at: index) }
                case .sortPost(let sortType):
                    currentSort = sortType
                    sortCurrentPosts()
                case .chipSelect(let index):
                    selectChips(at: index)
                case .segmentSelect(let index):
                    currentSegment = index
                    Task { await self.loadPosts() }
                case .blockUser(let user):
                    Task { await self.blockUser(to: user) }
                case .loadKeywords:
                    Task { await self.loadKeywords() }
                case .deleteRecentKeyword(let index):
                    Task { await self.deleteRecentKeyword(index: index) }
                case .deleteRecentAllKeywords:
                    Task { await self.deleteAllRecentKeywords() }
                case .search(let term):
                    searchTerm = term
                    Task { await self.loadPosts() }
                case .clearSearch:
                    searchTerm = ""
                    Task { await self.loadPosts() }
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

extension SocialListViewModel {
    private func loadPosts() async {
        let category = (currentSegment == 0) ? nil : currentCategory
        do {
            if isSearching {
                try await saveKeywords(term: searchTerm)
                let results = try await searchPostUseCase.execute(keyword: searchTerm, category: category) ?? []
                searchPosts = results
                
                let sorted = sortPosts(array: searchPosts, by: currentSort)
                searchPosts = sorted
                
                output.send(.searchPosts(searchPosts))
            } else {
                let results = try await fetchPostUseCase.execute(category: category) ?? []
                defaultPosts = sortPosts(array: results, by: currentSort)
                
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

    private func likePost(at index: Int) async {
        let postID = posts[index].id

        do {
            let resultPost = try await togglePostLikeUseCase.execute(postID: postID)
            
            if let defaultIndex = defaultPosts.firstIndex(where: { $0.id == postID }) {
                defaultPosts[defaultIndex] = resultPost
            }
            if let searchIndex = searchPosts.firstIndex(where: { $0.id == postID }) {
                searchPosts[searchIndex] = resultPost
            }

            output.send(.likePost(resultPost))

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

    private func blockUser(to user: User) async {
        do {
            _ = try await blockUserUseCase.execute(userID: user.id)
            // TODO: 차단 기능에 대한 후처리
        } catch {
            output.send(.failure("사용자 차단에 실패했습니다."))
        }
    }
    
    // MARK: - Keywords

    private func loadKeywords() async {
        // TODO: UserDefault 등에서 가져오는 로직
        output.send(.updateKeywords)
    }
    
    private func deleteRecentKeyword(index: Int) async {
        guard index >= 0, index < recentKeywords.count else { return }
        // TODO: UserDefault에서 삭제
        recentKeywords.remove(at: index)
        output.send(.updateKeywords)
    }
    
    private func deleteAllRecentKeywords() async {
        // TODO: UserDefault에서 전체 삭제
        recentKeywords.removeAll()
        output.send(.updateKeywords)
    }
    
    /// 검색어 저장 (이미 존재하면 맨 앞으로 이동)
    private func saveKeywords(term: String) async throws {
        if let index = recentKeywords.firstIndex(where: { $0.word == term }) {
            let keyword = recentKeywords.remove(at: index)
            recentKeywords.insert(keyword, at: 0)
        } else {
            recentKeywords.insert(Keyword(word: term), at: 0)
        }
    }
}
