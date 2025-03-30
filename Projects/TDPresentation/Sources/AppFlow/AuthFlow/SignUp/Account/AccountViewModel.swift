import Combine
import TDDomain
import Foundation

final class AccountViewModel: BaseViewModel {
    enum Input {
        case duplicateIdVerification
        case validateId(String)
        case validatePassword(String)
        case checkPasswordMatch(String, String)
        case registerUser
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
        case duplicateId
        case notDuplicateId
        case successRegister
        case failureRegister(message: String)
    }
    
    private let checkDuplicateUserIdUseCase: CheckDuplicateUserIdUseCase
    private let registerUserUseCase: RegisterUserUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let phoneNumber: String
    private var isIdValid = false
    private var isPasswordValid = false
    private var isPasswordMatched = false
    private var loginId = ""
    private var password = ""
    private var verifyPassword = ""
    
    init(
        checkDuplicateUserIdUseCase: CheckDuplicateUserIdUseCase,
        registerUserUseCase: RegisterUserUseCase,
        phoneNumber: String
    ) {
        self.checkDuplicateUserIdUseCase = checkDuplicateUserIdUseCase
        self.registerUserUseCase = registerUserUseCase
        self.phoneNumber = phoneNumber
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .validateId(let id):
                self?.validateId(id)
            case .validatePassword(let password):
                self?.validatePassword(password)
            case .checkPasswordMatch(let password, let verifyPassword):
                self?.checkPasswordMatch(password, verifyPassword)
            case .duplicateIdVerification:
                Task { await self?.duplicateIdVerification() }
            case .registerUser:
                Task { await self?.registerUser() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func validateId(_ id: String) {
        let regex = "^(?=.*[a-z])(?=.*[0-9])[a-z0-9]{5,20}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
        isIdValid = isValid
        loginId = id
        output.send(isValid ? .validId : .invalidIdFormat)
        updateNextButtonState()
        output.send(.updateDuplicateVerificationButtonState(isEnabled: isValid))
    }
    
    private func validatePassword(_ password: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        isPasswordValid = isValid
        self.password = password
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
        let isEnabled = isIdValid && isPasswordValid && isPasswordMatched
        output.send(.updateNextButtonState(isEnabled: isEnabled))
    }
    
    private func duplicateIdVerification() async {
        do {
            try await checkDuplicateUserIdUseCase.execute(loginId: loginId)
            output.send(.notDuplicateId)
        } catch {
            output.send(.duplicateId)
        }
    }
    
    private func registerUser() async {
        do {
            try await registerUserUseCase.execute(
                user: RegisterUser(
                    phoneNumber: phoneNumber,
                    loginId: loginId,
                    password: password
                )
            )
            output.send(.successRegister)
        } catch {
            output.send(.failureRegister(message: error.localizedDescription))
        }
    }
}
