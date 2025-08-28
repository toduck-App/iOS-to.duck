import Foundation
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
    
    public func requestRegisterUser(user: RegisterUser) async throws {
        let phoneNumber = user.phoneNumber
        let loginId = user.loginId
        let password = user.password
        try await service.requestRegisterUser(phoneNumber: phoneNumber, loginId: loginId, password: password)
    }
    
    public func requestPhoneVerification(with phoneNumber: String) async throws {
        try await service.requestPhoneVerification(with: phoneNumber)
    }
    
    public func checkPhoneVerification(phoneNumber: String, verifiedCode: String) async throws {
        try await service.checkPhoneVerification(phoneNumber: phoneNumber, verifiedCode: verifiedCode)
    }
    
    public func checkDuplicateUserID(loginId: String) async throws {
        try await service.checkDuplicateUserID(loginId: loginId)
    }
    
    public func requestKakaoLogin() async throws {
        let idToken = try await service.requestKakaoLogin()
        TDLogger.info("[앱] 카카오로부터 IDToken을 받았습니다.")

        guard let payload = await JWTDecoder.shared.decode(token: idToken),
              let oauthId = payload["sub"] as? String else {
            TDLogger.error("[앱] 카카오 idToken 디코딩 실패 또는 sub 없음")
            throw TDDataError.invalidIDToken
        }

        TDLogger.info("[앱] 디코딩된 oauthId(sub): \(oauthId)")
        let loginUserResponseDTO = try await service.requestOauthRegister(
            oauthProvider: AuthProvider.kakao.rawValue,
            oauthId: oauthId,
            idToken: idToken
        )
        try await saveToken(response: loginUserResponseDTO)
    }
    
    public func requestAppleLogin(oauthId: String, idToken: String) async throws {
        let loginUserResponseDTO = try await service.requestOauthRegister(
            oauthProvider: AuthProvider.apple.rawValue,
            oauthId: oauthId,
            idToken: idToken
        )
        try await saveToken(response: loginUserResponseDTO)
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
