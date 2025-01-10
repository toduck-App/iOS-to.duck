import Combine
import TDDomain

final class SocialSearchViewModel: BaseViewModel {
    enum Input {
        case loadInitialData
        case deleteRecentKeyword(index: Int)
        case search(query: String)
        case selectPost(post: Post.ID)
    }
    
    enum Output {
        case updateRecentKeywords
        case updatePopularKeywords
        case searchResult
        case selectPost
        case failure(String)
    }
    
    private let searchPostUseCase: SearchPostUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private(set) var recentKeywords: [String] = []
    private(set) var popularKeywords: [String] = []
    private(set) var searchResult: [Post] = []
    private(set) var selectedPostID: Post.ID?
    
    init(searchPostUseCase: SearchPostUseCase) {
        self.searchPostUseCase = searchPostUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .loadInitialData:
                Task { await self.loadKeywords() }
            case .deleteRecentKeyword(index: let index):
                deleteRecentKeyword(index: index)
            case .search(let term):
                Task { await self.searchPost(term: term) }
            case .selectPost(let post):
                selectPost(postID: post)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func searchPost(term: String) async {
        do {
            saveKeywords(term: term)
            let posts = try await searchPostUseCase.execute(keyword: term)
            searchResult = posts ?? []
            output.send(.searchResult)
            
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    func selectPost(postID: Post.ID) {
        selectedPostID = postID
        output.send(.selectPost)
    }
    
    private func loadKeywords() async {
        recentKeywords = ["콘서타", "루틴", "불면증"]
        popularKeywords = ["루틴", "집중", "뽀모도로", "꿀팁", "시간관리", "ADHD", "일기"]
        output.send(.updateRecentKeywords)
        output.send(.updatePopularKeywords)
    }
    
    private func deleteRecentKeyword(index: Int) {
        recentKeywords.remove(at: index)
        output.send(.updateRecentKeywords)
    }
    
    private func saveKeywords(term: String) {
        // UserDefaults에 저장, 중복 검사와 최대 치를 넘어가면 최근 검색어 삭제하는 로직이 Repository나 UseCase에서 처리되어야 할 것 같음.
        self.recentKeywords.append(term)
        output.send(.updateRecentKeywords)
    }
}
