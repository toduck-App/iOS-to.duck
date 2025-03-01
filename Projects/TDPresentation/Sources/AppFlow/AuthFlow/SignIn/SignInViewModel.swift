import Combine
import Foundation
import TDDomain

final class SignInViewModel: BaseViewModel {
    enum Input {
        case loginIdChanged(String)
        case passwordChanged(String)
        case didTapSignIn
    }
    
    enum Output {
        case validSignIn
    }
    
    private let loginUseCase: LoginUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var loginId = ""
    private var password = ""
    
    init(
        loginUseCase: LoginUseCase
    ) {
        self.loginUseCase = loginUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .loginIdChanged(let loginId):
                self?.loginId = loginId
            case .passwordChanged(let password):
                self?.password = password
            case .didTapSignIn:
                self?.handleSignIn()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleSignIn() {
        Task {
            try await loginUseCase.execute(loginId: loginId, password: password)
        }
    }
}

