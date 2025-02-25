import Combine
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
        case verificationCodeValid
        case updateVerificationTimer(time: String)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var timer: AnyCancellable?
    private var verificationTimeRemaining = 300

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .postPhoneNumber(let id, let phoneNumber):
                self?.validatePhoneNumber(id: id, phoneNumber: phoneNumber)
            case .postVerificationCode(let code):
                self?.validateVerificationCode(with: code)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }

    private func validatePhoneNumber(id: String, phoneNumber: String) {
        guard id.count >= 5 && id.count <= 20 else {
            output.send(.phoneNumberInvalid)
            return
        }
        
        guard isValidPhoneNumber(with: phoneNumber) else {
            output.send(.phoneNumberInvalid)
            return
        }
        
        output.send(.phoneNumberValid)
        startVerificationTimer()
    }
    
    private func isValidPhoneNumber(with phoneNumber: String) -> Bool {
        let phoneRegex = #"^01[0-9]{8,9}$"#
        return phoneNumber.range(of: phoneRegex, options: .regularExpression) != nil
    }

    private func validateVerificationCode(with code: String) {
        guard isValidVerificationCode(with: code) else {
            output.send(.verificationCodeInvalid)
            return
        }
        
        output.send(.verificationCodeValid)
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
