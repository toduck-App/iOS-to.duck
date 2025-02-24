import Combine
import Foundation

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
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var timer: AnyCancellable?
    private var remainingSeconds = 300

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .postPhoneNumber(let phoneNumber):
                self?.validatePhoneNumber(phoneNumber)
            case .postVerificationCode(let code):
                self?.validateVerificationCode(code)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }

    private func validatePhoneNumber(_ phoneNumber: String) {
        guard phoneNumber.range(of: #"^01[0-9]{8,9}$"#, options: .regularExpression) != nil else {
            output.send(.phoneNumberInvalid)
            return
        }
        
        output.send(.phoneNumberValid)
        startVerificationTimer()
    }

    private func validateVerificationCode(_ code: String) {
        guard code.count == 6, code.allSatisfy({ $0.isNumber }) else {
            output.send(.verificationCodeInvalid)
            return
        }
        
        output.send(.verificationCodeValid)
    }
    
    private func startVerificationTimer() {
        timer?.cancel()
        remainingSeconds = 300

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    let minutes = self.remainingSeconds / 60
                    let seconds = self.remainingSeconds % 60
                    let timeString = String(format: "%01d:%02d", minutes, seconds)
                    self.output.send(.updateVerificationTimer(time: timeString))
                } else {
                    self.timer?.cancel()
                    self.output.send(.verificationCodeInvalid)
                }
            }
    }
}
