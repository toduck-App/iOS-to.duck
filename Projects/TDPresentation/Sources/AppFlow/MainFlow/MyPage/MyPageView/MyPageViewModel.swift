import Combine
import TDDomain
import Foundation

final class MyPageViewModel: BaseViewModel {
    enum Input {
        case fetchUserNickname
        case logout
    }
    
    enum Output {
        case fetchedUserNickname(String)
        case logoutFinished
        case failureAPI(String)
    }
    
    private let fetchUserNicknameUseCase: FetchUserNicknameUseCase
    private let userLogoutUseCase: UserLogoutUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchUserNicknameUseCase: FetchUserNicknameUseCase,
        userLogoutUseCase: UserLogoutUseCase
    ) {
        self.fetchUserNicknameUseCase = fetchUserNicknameUseCase
        self.userLogoutUseCase = userLogoutUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchUserNickname:
                Task { await self?.fetchUserNickname() }
            case .logout:
                Task { await self?.logout() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUserNickname() async {
        do {
            let nickname = try await fetchUserNicknameUseCase.execute()
            output.send(.fetchedUserNickname(nickname))
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

