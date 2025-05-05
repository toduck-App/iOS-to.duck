import Combine
import TDCore
import TDDomain

final class MyPostViewModel: BaseViewModel {
    enum Input {
        case fetchUser
        case fetchPosts
        case loadMorePosts
    }
    
    enum Output {
        case fetchPosts
        case fetchUser(UserDetail)
        case failure(String)
    }
    
    private let fetchUserPostUseCase: FetchUserPostUseCase
    private let fetchUserUseCase: FetchUserUseCase
    private var fetchCursor = SocialCursor()
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var isLoadingMore: Bool = false
    private(set) var userDetail: UserDetail?
    private(set) var posts: [Post] = []
    
    init(fetchUserPostUseCase: FetchUserPostUseCase,
         fetchUserUseCase: FetchUserUseCase)
    {
        self.fetchUserPostUseCase = fetchUserPostUseCase
        self.fetchUserUseCase = fetchUserUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .fetchUser:
                Task { await self.fetchUser() }
            case .fetchPosts:
                Task { await self.fetchPosts() }
            case .loadMorePosts:
                guard !isLoadingMore else { return }
                isLoadingMore = true
                Task {
                    await self.loadMorePosts()
                    self.isLoadingMore = false
                }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUser() async {
        do {
            guard let userId = TDTokenManager.shared.userId else {
                output.send(.failure("사용자 정보를 불러올 수 없습니다."))
                return
            }
            let (_, userDetail) = try await fetchUserUseCase.execute(id: userId)
            self.userDetail = userDetail
            output.send(.fetchUser(userDetail))
        } catch {
            output.send(.failure("유저를 찾을 수 없습니다."))
        }
    }
    
    private func fetchPosts() async {
        do {
            guard let userId = TDTokenManager.shared.userId else {
                output.send(.failure("사용자 정보를 불러올 수 없습니다."))
                return
            }
            fetchCursor.reset()
            let result = try await fetchUserPostUseCase.execute(userID: userId, cursor: fetchCursor.nextCursor, limit: 20)
            fetchCursor.update(with: (result.hasMore, result.nextCursor))
            posts = result.result
            output.send(.fetchPosts)
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }
    
    private func loadMorePosts() async {
        do {
            guard let userId = TDTokenManager.shared.userId else {
                output.send(.failure("사용자 정보를 불러올 수 없습니다."))
                return
            }
            guard fetchCursor.hasMore else { return }
            let result = try await fetchUserPostUseCase.execute(userID: userId, cursor: fetchCursor.nextCursor, limit: 20)
            fetchCursor.update(with: (result.hasMore, result.nextCursor))
            posts.append(contentsOf: result.result)
            output.send(.fetchPosts)
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }
}
