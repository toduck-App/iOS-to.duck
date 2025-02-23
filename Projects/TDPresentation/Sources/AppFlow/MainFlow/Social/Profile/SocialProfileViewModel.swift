import Combine
import Foundation
import TDDomain

final class SocialProfileViewModel: BaseViewModel {
    enum Input {
        case fetchRoutine
        case fetchPosts
        case fetchUser
        case fetchUserDetail
    }
    
    enum Output {
        case fetchRoutine
        case fetchPosts
        case fetchUser
        case fetchUserDetail
        case failure(String)
    }
    
    private let fetchUserDetailUseCase: FetchUserDetailUseCase
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchUserPostUseCase: FetchUserPostUseCase
    private let userId: User.ID
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var user: User?
    private(set) var userDetail: UserDetail?
    private(set) var posts: [Post] = []
    
    init(
        id: User.ID,
        fetchUserDetailUseCase: FetchUserDetailUseCase,
        fetchUserUseCase: FetchUserUseCase,
        fetchUserPostUseCase: FetchUserPostUseCase
    ) {
        self.userId = id
        self.fetchUserDetailUseCase = fetchUserDetailUseCase
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchUserPostUseCase = fetchUserPostUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .fetchRoutine:
                break
            case .fetchPosts:
                Task { await self?.fetchPosts() }
            case .fetchUser:
                Task { await self?.fetchUser() }
            case .fetchUserDetail:
                Task { await self?.fetchUserDetail() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUser() async {
        do {
            let user = try await fetchUserUseCase.execute(id: userId)
            self.user = user
            output.send(.fetchUser)
        } catch {
            output.send(.failure("유저를 찾을 수 없습니다."))
        }
    }
    
    private func fetchUserDetail() async {
        do {
            let userDetail = try await fetchUserDetailUseCase.execute(id: userId)
            self.userDetail = userDetail
            output.send(.fetchUserDetail)
        } catch {
            output.send(.failure("유저를 찾을 수 없습니다."))
        }
    }
    
    private func fetchPosts() async {
        do {
            let posts = try await fetchUserPostUseCase.execute(id: userId)
            self.posts = posts ?? []
            output.send(.fetchPosts)
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }
    
    private func fetchRoutines() async {}
}
