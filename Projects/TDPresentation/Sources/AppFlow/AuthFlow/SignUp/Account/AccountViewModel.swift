import Combine
import Foundation

final class AccountViewModel: BaseViewModel {
    enum Input {
        case validateId(String)
        case validatePassword(String)
        case checkPasswordMatch(String, String)
    }
    
    enum Output {
        case invalidIdFormat
        case validId
        case invalidPassword
        case validPassword
        case passwordMismatch
        case passwordMatched
        case updateNextButtonState(isEnabled: Bool)
        case updateDuplicateVerificationButtonState(isEnabled: Bool)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var isIdValid = false
    private var isPasswordValid = false
    private var isPasswordMatched = false
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .validateId(let id):
                self?.validateId(id)
            case .validatePassword(let password):
                self?.validatePassword(password)
            case .checkPasswordMatch(let password, let verifyPassword):
                self?.checkPasswordMatch(password, verifyPassword)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func validateId(_ id: String) {
        let regex = "^[a-z0-9]{5,20}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
        isIdValid = isValid
        output.send(isValid ? .validId : .invalidIdFormat)
        updateNextButtonState()
        output.send(.updateDuplicateVerificationButtonState(isEnabled: isValid))
    }
    
    private func validatePassword(_ password: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        isPasswordValid = isValid
        output.send(isValid ? .validPassword : .invalidPassword)
        updateNextButtonState()
    }
    
    private func checkPasswordMatch(_ password: String, _ verifyPassword: String) {
        isPasswordMatched = password == verifyPassword
        output.send(isPasswordMatched ? .passwordMatched : .passwordMismatch)
        updateNextButtonState()
    }

    private func updateNextButtonState() {
        let isEnabled = isIdValid && isPasswordValid && isPasswordMatched
        output.send(.updateNextButtonState(isEnabled: isEnabled))
    }
}
