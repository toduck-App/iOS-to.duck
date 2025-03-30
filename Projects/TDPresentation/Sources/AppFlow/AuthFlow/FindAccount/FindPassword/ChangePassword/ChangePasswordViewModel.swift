import Combine
import TDDomain
import Foundation

final class ChangePasswordViewModel: BaseViewModel {
    enum Input {
        case changePassword
        case validatePassword(String)
        case checkPasswordMatch(String, String)
    }
    
    enum Output {
        case validPassword
        case invalidPassword
        case passwordMatched
        case passwordMismatch
        case updateNextButtonState(isEnabled: Bool)
        case failureAPI(String)
    }
    
    private let changePasswordUseCase: ChangePasswordUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let phoneNumber: String
    private let loginId: String
    private var isPasswordValid = false
    private var isPasswordMatched = false
    private var changedPassword = ""
    private var verifyPassword = ""
    
    init(
        changePasswordUseCase: ChangePasswordUseCase,
        phoneNumber: String,
        loginId: String
    ) {
        self.changePasswordUseCase = changePasswordUseCase
        self.phoneNumber = phoneNumber
        self.loginId = loginId
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .validatePassword(let password):
                self?.validatePassword(password)
            case .checkPasswordMatch(let password, let verifyPassword):
                self?.checkPasswordMatch(password, verifyPassword)
            case .changePassword:
                Task { await self?.changePassword() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func validatePassword(_ password: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        isPasswordValid = isValid
        self.changedPassword = password
        output.send(isValid ? .validPassword : .invalidPassword)
        updateNextButtonState()
    }
    
    private func checkPasswordMatch(_ password: String, _ verifyPassword: String) {
        isPasswordMatched = password == verifyPassword
        self.verifyPassword = verifyPassword
        output.send(isPasswordMatched ? .passwordMatched : .passwordMismatch)
        updateNextButtonState()
    }

    private func updateNextButtonState() {
        let isEnabled = isPasswordValid && isPasswordMatched
        output.send(.updateNextButtonState(isEnabled: isEnabled))
    }
    
    private func changePassword() async {
        guard isPasswordValid && isPasswordMatched else { return }
        
        do {
            try await changePasswordUseCase.execute(
                loginId: loginId,
                changedPassword: changedPassword,
                phoneNumber: phoneNumber
            )
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}

