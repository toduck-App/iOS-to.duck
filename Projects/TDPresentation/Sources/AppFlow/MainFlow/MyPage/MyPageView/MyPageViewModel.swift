import Combine
import Foundation
import TDCore
import TDDomain

final class MyPageViewModel: BaseViewModel {
    enum Input {
        case fetchUserNickname
        case fetchUserDetail
        case logout
    }
    
    enum Output {
        case fetchedUserNickname(String)
        case fetchedUserDetail(User, UserDetail)
        case logoutFinished
        case failureAPI(String)
    }
    
    private let fetchUserNicknameUseCase: FetchUserNicknameUseCase
    private let fetchUserDetailUseCase: FetchUserUseCase
    private let userLogoutUseCase: UserLogoutUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var nickName: String?
    private(set) var user: User?
    
    init(
        fetchUserNicknameUseCase: FetchUserNicknameUseCase,
        fetchUserDetailUseCase: FetchUserUseCase,
        userLogoutUseCase: UserLogoutUseCase
    ) {
        self.fetchUserNicknameUseCase = fetchUserNicknameUseCase
        self.fetchUserDetailUseCase = fetchUserDetailUseCase
        self.userLogoutUseCase = userLogoutUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchUserNickname:
                Task { await self?.fetchUserNickname() }
            case .fetchUserDetail:
                Task { await self?.fetchUserDetail() }
            case .logout:
                Task { await self?.logout() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUserNickname() async {
        do {
            let nickname = try await fetchUserNicknameUseCase.execute()
            self.nickName = nickname
            output.send(.fetchedUserNickname(nickname))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func fetchUserDetail() async {
        do {
            guard let userId = TDTokenManager.shared.userId else { return }
            let (user, userDetail) = try await fetchUserDetailUseCase.execute(id: userId)
            self.user = user
            output.send(.fetchedUserDetail(user, userDetail))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func logout() async {
        do {
            try await userLogoutUseCase.execute()
            output.send(.logoutFinished)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
