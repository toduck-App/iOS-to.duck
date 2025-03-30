import Combine
import TDDomain
import Foundation

final class FindPasswordViewModel: BaseViewModel {
    enum Input {
        case postPhoneNumber(id: String, phoneNumber: String)
        case postVerificationCode(code: String)
    }
    
    enum Output {
        case phoneNumberValid
        case phoneNumberInvalid
        case verificationCodeInvalid
        case verificationCodeValid(phoneNumber: String, loginId: String)
        case updateVerificationTimer(time: String)
        case failureAPI(String)
    }
    
    private let requestVerificationCodeForFindUserUseCase: RequestVerificationCodeForFindUserUseCase
    private let verifyPhoneCodeUseCase: VerifyPhoneCodeUseCase
    private let requestValidFindUserUseCase: RequestValidFindUserUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var phoneNumber = ""
    private var loginId = ""
    private var timer: AnyCancellable?
    private var verificationTimeRemaining = 300
    
    init(
        requestVerificationCodeForFindUserUseCase: RequestVerificationCodeForFindUserUseCase,
        verifyPhoneCodeUseCase: VerifyPhoneCodeUseCase,
        requestValidFindUserUseCase: RequestValidFindUserUseCase
    ) {
        self.requestVerificationCodeForFindUserUseCase = requestVerificationCodeForFindUserUseCase
        self.requestValidFindUserUseCase = requestValidFindUserUseCase
        self.verifyPhoneCodeUseCase = verifyPhoneCodeUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .postPhoneNumber(let id, let phoneNumber):
                Task { await self?.validatePhoneNumber(id: id, phoneNumber: phoneNumber) }
            case .postVerificationCode(let code):
                Task { await self?.validateVerificationCode(with: code) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func validatePhoneNumber(id: String, phoneNumber: String) async {
        guard id.count >= 5 && id.count <= 20 else {
            output.send(.phoneNumberInvalid)
            return
        }
        
        guard isValidPhoneNumber(with: phoneNumber) else {
            output.send(.phoneNumberInvalid)
            return
        }
        self.phoneNumber = phoneNumber
        self.loginId = id
        
        do {
            try await requestVerificationCodeForFindUserUseCase.execute(phoneNumber: phoneNumber)
            startVerificationTimer()
            output.send(.phoneNumberValid)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func isValidPhoneNumber(with phoneNumber: String) -> Bool {
        let phoneRegex = #"^01[0-9]{8,9}$"#
        return phoneNumber.range(of: phoneRegex, options: .regularExpression) != nil
    }
    
    private func validateVerificationCode(with code: String) async {
        guard isValidVerificationCode(with: code) else {
            output.send(.verificationCodeInvalid)
            return
        }
        
        do {
            try await verifyPhoneCodeUseCase.execute(phoneNumber: phoneNumber, verifiedCode: code)
            try await requestValidFindUserUseCase.execute(loginId: loginId, phoneNumber: phoneNumber)
            output.send(.verificationCodeValid(phoneNumber: phoneNumber, loginId: loginId))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func isValidVerificationCode(with code: String) -> Bool {
        return code.count == 5 && code.allSatisfy { $0.isNumber }
    }
    
    private func startVerificationTimer() {
        timer?.cancel()
        verificationTimeRemaining = 300
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.verificationTimeRemaining > 0 {
                    self.verificationTimeRemaining -= 1
                    let minutes = self.verificationTimeRemaining / 60
                    let seconds = self.verificationTimeRemaining % 60
                    let timeString = String(format: "%01d:%02d", minutes, seconds)
                    self.output.send(.updateVerificationTimer(time: timeString))
                } else {
                    self.timer?.cancel()
                    self.output.send(.verificationCodeInvalid)
                }
            }
    }
}
