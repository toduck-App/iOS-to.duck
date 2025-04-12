import Combine
import Foundation
import TDDomain

final class SocialProfileViewModel: BaseViewModel {
    enum Input {
        case fetchRoutine
        case fetchPosts
        case fetchUser
        case loadMorePosts
        case toggleFollow
    }
    
    enum Output {
        case fetchRoutine
        case fetchPosts
        case fetchUser(User, UserDetail)
        case failure(String)
    }
    
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchUserPostUseCase: FetchUserPostUseCase
    private let toggleUserFollowUseCase: ToggleUserFollowUseCase
    private let fetchRoutineListUseCase: FetchRoutineListUseCase
    private let userId: User.ID
    private var fetchCursor = SocialCursor()
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var isLoadingMore: Bool = false
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
            guard let self else { return }
            switch input {
            case .fetchRoutine:
                Task { await self.fetchRoutines() }
            case .fetchPosts:
                Task { await self.fetchPosts() }
            case .fetchUser:
                Task { await self.fetchUser() }
            case .toggleFollow:
                Task { await self.toggleFollow() }
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
            let (user, userDetail) = try await fetchUserUseCase.execute(id: userId)
            self.user = user
            self.userDetail = userDetail
            output.send(.fetchUser(user, userDetail))
        } catch {
            output.send(.failure("유저를 찾을 수 없습니다."))
        }
    }
    
    private func fetchPosts() async {
        do {
            fetchCursor.reset()
            let result = try await fetchUserPostUseCase.execute(userID: userId, cursor: fetchCursor.nextCursor, limit: 20)
            fetchCursor.update(with: (result.hasMore, result.nextCursor))
            self.posts = result.result
            output.send(.fetchPosts)
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }
    
    private func fetchRoutines() async {
        do {
//            let routines = try await fetchRoutineListUseCase.execute(userId: userId)
//            self.routines = routines
            output.send(.fetchRoutine)
        } catch {
            output.send(.failure("루틴을 불러오는데 실패했습니다."))
        }
    }
    
    private func toggleFollow() async {
        do {
            guard let user = self.user, var userDetail = self.userDetail else { return }
            try await toggleUserFollowUseCase.execute(currentFollowState: userDetail.isFollowing, targetUserID: user.id)
            userDetail.isFollowing.toggle()
            userDetail.followerCount += userDetail.isFollowing ? 1 : -1
            output.send(.fetchUser(user, userDetail))
            self.userDetail = userDetail
        } catch {
            output.send(.failure("팔로잉에 실패했습니다."))
        }
    }
    
    private func loadMorePosts() async {
        do {
            guard fetchCursor.hasMore else { return }
            let result = try await fetchUserPostUseCase.execute(userID: userId, cursor: fetchCursor.nextCursor, limit: 20)
            fetchCursor.update(with: (result.hasMore, result.nextCursor))
            self.posts.append(contentsOf: result.result)
            output.send(.fetchPosts)
        } catch {
            output.send(.failure("게시글을 불러오는데 실패했습니다."))
        }
    }
}
