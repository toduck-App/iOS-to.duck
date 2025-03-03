import TDCore
import TDDomain
import TDData
import Foundation
import KakaoSDKUser

public struct AuthServiceImpl: AuthService {
    private let provider: MFProvider<AuthAPI>
    
    public init(provider: MFProvider<AuthAPI> = MFProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    public func requestOauthRegister(oauthProvider: String, oauthId: String, idToken: String) async throws {
        let response = try await provider.request(.loginOauth(provider: oauthProvider, oauthId: oauthId, idToken: idToken))
        
        if let statusCode = response.httpResponse?.statusCode {
            switch statusCode {
            case 200..<300:
                TDLogger.info("우리 서버로 로그인 요청 성공")
                return
            case 403:
                TDLogger.error("[Oauth 로그인 실패]: IDToken 잘못됨")
                throw TDDataError.invalidIDToken
            case 404:
                TDLogger.error("[Oauth 로그인 실패]: 공개키 잘못됨")
                throw TDDataError.notFoundPulbicKey
            case 500..<600:
                TDLogger.error("[Oauth 로그인 실패]: 서버 에러")
                throw TDDataError.serverError
            default:
                throw TDDataError.generalFailure
            }
        }
        
        throw TDDataError.requestLoginFailure
    }
    
    public func requestKakaoLogin() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            TDLogger.info("[AuthServiceImpl] 카카오톡 앱으로 로그인 인증")
            return try await handleKakaoLoginWithApp()
        } else {
            TDLogger.info("[AuthServiceImpl] 카톡이 설치가 안 되어 웹뷰 실행")
            return try await handleKakaoLoginWithAccount()
        }
    }
    
    private func handleKakaoLoginWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let idToken = oauthToken?.idToken else {
                    continuation.resume(throwing: TDDataError.invalidIDToken)
                    return
                }
                
                continuation.resume(returning: idToken)
            }
        }
    }
    
    private func handleKakaoLoginWithAccount() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let idToken = oauthToken?.idToken else {
                    continuation.resume(throwing: TDDataError.invalidIDToken)
                    return
                }
                continuation.resume(returning: idToken)
            }
        }
    }
}
