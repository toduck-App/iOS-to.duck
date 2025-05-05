import Combine
import TDCore
import TDDomain

final class MyCommentViewModel: BaseViewModel {
    enum Input {
        case fetchUser
        case fetchComments
        case loadMoreComments
    }
    
    enum Output {
        case fetchComments
        case fetchUser(UserDetail)
        case failure(String)
    }
    
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchCommentUseCase: FetchCommentUseCase
    private var fetchCursor = SocialCursor()
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var isLoadingMore: Bool = false
    private(set) var userDetail: UserDetail?
    private(set) var comments: [Comment] = []
    
    init(fetchUserUseCase: FetchUserUseCase,
         fetchCommentUseCase: FetchCommentUseCase)
    {
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchCommentUseCase = fetchCommentUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .fetchUser:
                Task { await self.fetchUser() }
            case .fetchComments:
                Task { await self.fetchComments() }
            case .loadMoreComments:
                guard !isLoadingMore else { return }
                isLoadingMore = true
                Task {
                    await self.loadMoreComments()
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
            output.send(.failure(error.localizedDescription))
        }
    }
    
    private func fetchComments() async {
        do {
            fetchCursor.reset()
            let result = try await fetchCommentUseCase.execute(cursor: fetchCursor.nextCursor, limit: 20)
            fetchCursor.update(with: (result.hasMore, result.nextCursor))
            comments = result.result
            output.send(.fetchComments)
        } catch {
            output.send(.failure("댓글을 불러오는데 실패했습니다."))
        }
    }
    
    private func loadMoreComments() async {
        do {
            guard fetchCursor.hasMore else { return }
            let result = try await fetchCommentUseCase.execute(cursor: fetchCursor.nextCursor, limit: 20)
            fetchCursor.update(with: (result.hasMore, result.nextCursor))
            comments.append(contentsOf: result.result)
            output.send(.fetchComments)
        } catch {
            output.send(.failure("댓글을 불러오는데 실패했습니다."))
        }
    }
}
