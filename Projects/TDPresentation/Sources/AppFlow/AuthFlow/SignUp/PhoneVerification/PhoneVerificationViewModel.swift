import Combine
import Foundation
import TDDomain

final class PhoneVerificationViewModel: BaseViewModel {
    enum Input {
        case postPhoneNumber(phoneNumber: String)
        case postVerificationCode(code: String)
    }
    
    enum Output {
        case phoneNumberValid
        case phoneNumberInvalid
        case phoneNumberAlreadyExist
        case verificationCodeInvalid
        case verificationCodeValid
        case updateVerificationTimer(time: String)
        case apiFailure(error: String)
    }
    
    private let requestPhoneVerificationCodeUseCase: RequestPhoneVerificationCodeUseCase
    private let verifyPhoneCodeUseCase: VerifyPhoneCodeUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var timer: AnyCancellable?
    private var verificationTimeRemaining = 300
    private var phoneNumber: String = ""

    init(
        requestPhoneVerificationCodeUseCase: RequestPhoneVerificationCodeUseCase,
        verifyPhoneCodeUseCase: VerifyPhoneCodeUseCase
    ) {
        self.requestPhoneVerificationCodeUseCase = requestPhoneVerificationCodeUseCase
        self.verifyPhoneCodeUseCase = verifyPhoneCodeUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .postPhoneNumber(let phoneNumber):
                Task { await self?.validatePhoneNumber(with: phoneNumber) }
            case .postVerificationCode(let code):
                Task { await self?.validateVerificationCode(with: code) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }

    private func validatePhoneNumber(with phoneNumber: String) async {
        guard isValidPhoneNumber(with: phoneNumber) else {
            output.send(.phoneNumberInvalid)
            return
        }
        
        do {
            self.phoneNumber = phoneNumber
            try await requestPhoneVerificationCodeUseCase.execute(with: phoneNumber)
            output.send(.phoneNumberValid)
        } catch {
            output.send(.apiFailure(error: error.localizedDescription))
        }
        
        startVerificationTimer()
    }
    
    private func isValidPhoneNumber(with phoneNumber: String) -> Bool {
        let phoneRegex = #"^010[0-9]{8}$"#
        return phoneNumber.range(of: phoneRegex, options: .regularExpression) != nil
    }

    private func validateVerificationCode(with code: String) async {
        guard isValidVerificationCode(with: code) else {
            output.send(.verificationCodeInvalid)
            return
        }
        
        do {
            try await verifyPhoneCodeUseCase.execute(phoneNumber: phoneNumber, verifiedCode: code)
            output.send(.verificationCodeValid)
        } catch {
            output.send(.verificationCodeInvalid)
        }
    }
    
    private func isValidVerificationCode(with code: String) -> Bool {
        return code.count == 6 && code.allSatisfy { $0.isNumber }
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
