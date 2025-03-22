import Foundation
import KeyChainManager_KJ
import TDCore
import TDDomain

public struct AuthRepositoryImpl: AuthRepository {
    private let service: AuthService
    
    var kakaoAppKey: String {
        Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
    }
    
    public init(service: AuthService) {
        self.service = service
    }
    
    public func requestKakaoLogin() async throws {
        let idToken = try await service.requestKakaoLogin()
        TDLogger.info("[앱] 카카오로부터 IDToken을 받았습니다. 우리 서버로 \(idToken)을 전송합니다.")
        try await service.requestOauthRegister(oauthProvider: AuthProvider.kakao.rawValue, oauthId: kakaoAppKey, idToken: idToken)
    }
    
    public func requestAppleLogin(oauthId: String, idToken: String) async throws {
        try await service.requestOauthRegister(oauthProvider: AuthProvider.apple.rawValue, oauthId: oauthId, idToken: idToken)
    }
        
    public func requestLogin(
        loginId: String,
        password: String
    ) async throws {
        let loginUserResponseDTO = try await service.requestLogin(loginId: loginId, password: password)
        try await saveToken(response: loginUserResponseDTO)
    }
    
    public func refreshToken() async throws {
        let loginUserResponseDTO = try await service.refreshToken()
        try await saveToken(response: loginUserResponseDTO)
    }
    
    private func saveToken(response: LoginUserResponseDTO) async throws {
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        let refreshTokenExpiredAt = response.refreshTokenExpiredAt
        let userId = response.userId
        let token = (accessToken, refreshToken, refreshTokenExpiredAt, userId)
        try await TDTokenManager.shared.saveToken(token)
    }
}
