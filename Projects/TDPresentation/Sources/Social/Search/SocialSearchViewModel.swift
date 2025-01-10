import Combine
import TDDomain

final class SocialSearchViewModel: BaseViewModel {
    enum Input {
        case search(query: String)
        case selectPost(post: Post.ID)
    }
    
    enum Output {
        case searchResult
        case selectPost
        case failure(String)
    }
    
    private let searchPostUseCase: SearchPostUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private(set) var searchResult: [Post] = []
    private(set) var selectedPostID: Post.ID?
    
    init(searchPostUseCase: SearchPostUseCase) {
        self.searchPostUseCase = searchPostUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .search(let term):
                Task { await self.searchPost(term: term) }
            case .selectPost(let post):
                self.selectPost(postID: post)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func searchPost(term: String) async {
        do {
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
}
