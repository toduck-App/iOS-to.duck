import Combine
import AuthenticationServices
import UIKit
import TDCore
import TDDesign

final class AuthViewController: BaseViewController<AuthView> {
    // MARK: Properties
    private let viewModel: AuthViewModel
    private let input = PassthroughSubject<AuthViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: AuthCoordinator?
    
    // MARK: Initializer
    init(
        viewModel: AuthViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Base Methods
    override func configure() {
        layoutView.mainButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didMainButtonTapped()
        }, for: .touchUpInside)
        
        layoutView.kakaoLoginButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.signInWithKakao)
        }, for: .touchUpInside)
        
        layoutView.appleLoginButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.signInWithApple)
        }, for: .touchUpInside)
        
        layoutView.signInButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didSignInButtonTapped()
        }, for: .touchUpInside)
        
        layoutView.signUpButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didSignUpButtonTapped()
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .loginSuccess:
                    break
                case let .loginFailure(error):
                    TDLogger.error("로그인 실패: \(error)")
                }
            }.store(in: &cancellables)
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    // 로그인 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("로그인 실패", error.localizedDescription)
    }
    
    // Apple ID 로그인에 성공한 경우, 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            
            print("✅ Apple ID 로그인 성공")
            print("사용자 ID: \(userIdentifier)")
            print("전체 이름: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("이메일: \(email ?? "이메일 없음")")

            // 🔹 ID Token 디코딩
            if let identityToken = appleIdCredential.identityToken {
                let tokenString = String(data: identityToken, encoding: .utf8)
                print("🟢 Decoded ID Token: \(tokenString ?? "토큰 변환 실패")")
            } else {
                print("❌ ID Token이 없습니다.")
            }
            
            // 🔹 Authorization Code 디코딩
            if let authorizationCode = appleIdCredential.authorizationCode {
                let authCodeString = String(data: authorizationCode, encoding: .utf8)
                print("🟡 Decoded Authorization Code: \(authCodeString ?? "인증 코드 변환 실패")")
            }

            print("✅ 로그인 성공 완료")

        default:
            break
        }
    }
}

// MARK: ASAuthorizationController PresentationContextProviding
extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
