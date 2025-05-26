import Combine
import TDDomain
import TDCore
import AuthenticationServices
import Foundation

final class AuthViewModel: NSObject, BaseViewModel {
    enum Input {
        case signInWithKakao
        case signInWithApple
    }
    
    enum Output {
        case loginSuccess
        case loginFailure(error: String)
    }
    
    private let kakaoLoginUseCase: KakaoLoginUseCase
    private let appleLoginUseCase: AppleLoginUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        kakaoLoginUseCase: KakaoLoginUseCase,
        appleLoginUseCase: AppleLoginUseCase
    ) {
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.appleLoginUseCase = appleLoginUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .signInWithKakao:
                Task { await self?.signInWithKakao() }
            case .signInWithApple:
                self?.signInWithApple()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func signInWithKakao() async {
        do {
            try await kakaoLoginUseCase.execute()
            output.send(.loginSuccess)
        } catch {
            TDLogger.error("Kakao Login Error: \(error)")
            output.send(.loginFailure(error: "카카오 로그인에 실패했습니다."))
        }
    }
    
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
            let idToken = appleIdCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }

            if let idToken {
                Task {
                    if let payload = await JWTDecoder.shared.decode(token: idToken),
                       let oauthId = payload["sub"] as? String {
                        try await appleLoginUseCase.execute(oauthId: oauthId, idToken: idToken)
                        output.send(.loginSuccess)
                    } else {
                        output.send(.loginFailure(error: "idToken 디코딩 실패 또는 sub 없음"))
                    }
                }
            } else {
                output.send(.loginFailure(error: "idToken 없음"))
            }

        default:
            output.send(.loginFailure(error: "알 수 없는 인증 응답"))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        output.send(.loginFailure(error: "Apple 로그인에 실패했습니다."))
    }
}
