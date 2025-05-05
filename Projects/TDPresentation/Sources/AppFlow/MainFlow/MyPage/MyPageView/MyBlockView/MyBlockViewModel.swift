import Combine
import TDDomain

final class MyBlockViewModel: BaseViewModel {
    enum Input {
        case fetchBlockedUsers
        case blockUser(userId: User.ID)
        case unblockUser(userId: User.ID)
    }
    
    enum Output {
        case fetchBlockedUsers
        case failure(String)
    }
    
    private let fetchBlockedUsersUseCase: FetchBlockedUsersUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let unBlockUserUseCase: UnBlockUserUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var isBlockedState: [User.ID: Bool] = [:]
    
    private(set) var blockedUsers: [User] = []
    
    init(fetchBlockedUsersUseCase: FetchBlockedUsersUseCase,
         blockUserUseCase: BlockUserUseCase,
         unBlockUserUseCase: UnBlockUserUseCase)
    {
        self.fetchBlockedUsersUseCase = fetchBlockedUsersUseCase
        self.blockUserUseCase = blockUserUseCase
        self.unBlockUserUseCase = unBlockUserUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .fetchBlockedUsers:
                Task { await self.fetchBlockedUsers() }
            case .blockUser(let userId):
                Task { await self.blockUser(userId: userId) }
            case .unblockUser(let userId):
                Task { await self.unblockUser(userId: userId) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchBlockedUsers() async {
        do {
            let users = try await fetchBlockedUsersUseCase.execute()
            blockedUsers = users
            isBlockedState = Dictionary(uniqueKeysWithValues: users.map { ($0.id, true) })
            output.send(.fetchBlockedUsers)
        } catch {
            output.send(.failure("차단된 사용자 정보를 불러올 수 없습니다."))
        }
    }
    
    func blockUser(userId: User.ID) async {
        do {
            try await blockUserUseCase.execute(userID: userId)
            isBlockedState[userId] = true
        } catch {
            output.send(.failure("사용자를 차단할 수 없습니다."))
        }
    }
    
    func unblockUser(userId: User.ID) async {
        do {
            try await unBlockUserUseCase.execute(userID: userId)
            isBlockedState[userId] = false
        } catch {
            output.send(.failure("사용자의 차단을 해제할 수 없습니다."))
        }
    }
}
