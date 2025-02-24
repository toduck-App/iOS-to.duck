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
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
        output.send(isValid ? .validId : .invalidIdFormat)
    }
    
    private func validatePassword(_ password: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        output.send(isValid ? .validPassword : .invalidPassword)
    }
    
    private func checkPasswordMatch(_ password: String, _ verifyPassword: String) {
        output.send(password == verifyPassword ? .passwordMatched : .passwordMismatch)
    }
}
