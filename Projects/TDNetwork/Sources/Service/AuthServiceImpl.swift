import Foundation
import KakaoSDKUser
import TDCore
import TDData
import TDDomain

public struct AuthServiceImpl: AuthService {
    private let provider: MFProvider<AuthAPI>
    
    public init(provider: MFProvider<AuthAPI> = MFProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    public func requestOauthRegister(oauthProvider: String, oauthId: String, idToken: String) async throws -> LoginUserResponseDTO {
        let target = AuthAPI.loginOauth(provider: oauthProvider, oauthId: oauthId, idToken: idToken)
        let response = try await provider.requestDecodable(of: LoginUserResponseBody.self, target)
        
        return try mapToLoginUserResponseDTO(from: response)
    }
    
    public func requestLogin(
        loginId: String,
        password: String
    ) async throws -> LoginUserResponseDTO {
        let target = AuthAPI.login(loginId: loginId, password: password)
        let response = try await provider.requestDecodable(of: LoginUserResponseBody.self, target)

        return try mapToLoginUserResponseDTO(from: response)
    }

    public func refreshToken() async throws -> TDData.LoginUserResponseDTO {
        guard let refreshToken = TDTokenManager.shared.refreshToken else {
            throw TDDataError.invalidRefreshToken
        }
        let target = AuthAPI.refreshToken(refreshToken: refreshToken)
        let response = try await provider.requestDecodable(of: LoginUserResponseBody.self, target)
        
        return try mapToLoginUserResponseDTO(from: response)
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
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
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
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
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
    
    private func mapToLoginUserResponseDTO(from response: MFResponse<LoginUserResponseBody>) throws -> LoginUserResponseDTO {
        if let refreshToken = response.extractRefreshToken(),
           let refreshTokenExpiredAt = response.extractRefreshTokenExpiry() {
            return LoginUserResponseDTO(
                accessToken: response.value.accessToken,
                refreshToken: refreshToken,
                refreshTokenExpiredAt: refreshTokenExpiredAt,
                userId: response.value.userId
            )
        }
        throw TDDataError.requestLoginFailure
    }
}
