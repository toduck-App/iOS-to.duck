import Combine
import Foundation
import TDDomain

final class SocialProfileViewModel: BaseViewModel {
    enum Input {
        case fetchRoutine
        case fetchPosts
        case fetchUser
        case toggleFollow
    }
    
    enum Output {
        case fetchRoutine
        case fetchPosts
        case fetchUser
        case failure(String)
    }
    
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchUserPostUseCase: FetchUserPostUseCase
    private let toggleUserFollowUseCase: ToggleUserFollowUseCase
    private let fetchRoutineListUseCase: FetchRoutineListUseCase
    private let userId: User.ID
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var user: User?
    private(set) var userDetail: UserDetail?
    private(set) var posts: [Post] = []
    private(set) var routines: [Routine] = []
    
    init(
        id: User.ID,
        fetchUserUseCase: FetchUserUseCase,
        fetchUserPostUseCase: FetchUserPostUseCase,
        toggleUserFollowUseCase: ToggleUserFollowUseCase,
        fetchRoutineListUseCase: FetchRoutineListUseCase
    ) {
        self.userId = id
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchUserPostUseCase = fetchUserPostUseCase
        self.toggleUserFollowUseCase = toggleUserFollowUseCase
        self.fetchRoutineListUseCase = fetchRoutineListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case .fetchRoutine:
                Task { await self?.fetchRoutines() }
            case .fetchPosts:
                Task { await self?.fetchPosts() }
            case .fetchUser:
                Task { await self?.fetchUser() }
            case .toggleFollow:
                Task { await self?.toggleFollow() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUser() async {
        do {
            let (user, userDetail) = try await fetchUserUseCase.execute(id: userId)
            self.user = user
            self.userDetail = userDetail
            output.send(.fetchUser)
        } catch {
            output.send(.failure("유저를 찾을 수 없습니다."))
        }
    }
    
//    private func fetchUserDetail() async {
//        do {
//            let userDetail = try await fetchUserDetailUseCase.execute(id: userId)
//            self.userDetail = userDetail
//            output.send(.fetchUserDetail)
//        } catch {
//            output.send(.failure("유저를 찾을 수 없습니다."))
//        }
//    }
    
    private func fetchPosts() async {
        do {
            let posts = try await fetchUserPostUseCase.execute(id: userId)
            self.posts = posts ?? []
            output.send(.fetchPosts)
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }
    
    private func fetchRoutines() async {
        do {
            let routines = try await fetchRoutineListUseCase.execute(userId: userId)
            self.routines = routines
            output.send(.fetchRoutine)
        } catch {
            output.send(.failure("루틴을 불러오는데 실패했습니다."))
        }
    }
    
    private func toggleFollow() async {
        do {
            let isFollowed = try await toggleUserFollowUseCase.execute(userID: .init(), targetUserID: .init())
            self.userDetail?.isFollowing = isFollowed
            output.send(.fetchUser)
        } catch {
            output.send(.failure("팔로잉에 실패했습니다."))
        }
    }
}
