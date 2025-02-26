import Combine
import AuthenticationServices
import Foundation

final class AuthViewModel: NSObject, BaseViewModel {
    enum Input {
        case signInWithApple
    }
    
    enum Output {
        case loginSuccess(userID: String, email: String?, fullName: String?)
        case loginFailure(error: String)
        case tokenReceived(idToken: String?, authCode: String?)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .signInWithApple:
                self?.signInWithApple()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Apple 로그인 요청
    private func signInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            let userID = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            
            output.send(.loginSuccess(userID: userID, email: email, fullName: fullName?.givenName))
            
            // ID Token 및 Authorization Code 처리
            let idToken = appleIdCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
            let authCode = appleIdCredential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }
            
            output.send(.tokenReceived(idToken: idToken, authCode: authCode))
            
        default:
            output.send(.loginFailure(error: "알 수 없는 인증 응답"))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        output.send(.loginFailure(error: error.localizedDescription))
    }
}
