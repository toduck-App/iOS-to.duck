import TDCore
import Foundation
import TDDomain
import Foundation

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
        TDLogger.debug("Repo: \(loginId), \(password)")
        do {
            let loginUserResponseDTO = try await service.requestLogin(loginId: loginId, password: password)

            async let saveAccess = KeyChainManager.shared.save(string: loginUserResponseDTO.accessToken, account: KeyChainConstant.accessToken.rawValue)
            async let saveRefresh = KeyChainManager.shared.save(string: loginUserResponseDTO.refreshToken, account: KeyChainConstant.refreshToken.rawValue)
            async let saveRefreshExpiredAt = KeyChainManager.shared.save(string: loginUserResponseDTO.refreshTokenExpiredAt, account: KeyChainConstant.refreshTokenExpiredAt.rawValue)
            let saveUserIdData = try JSONEncoder().encode(loginUserResponseDTO.userId)
            async let saveUserId = KeyChainManager.shared.save(with: saveUserIdData, account: KeyChainConstant.userId.rawValue)
            
            _ = try await (saveAccess, saveRefresh, saveRefreshExpiredAt, saveUserId)
            TDLogger.info("로그인 정보 키체인 저장 완료")
            
        } catch {
            TDLogger.error("로그인 실패: \(error)")
            throw error // ✅ 실패 시 예외를 다시 던져서 상위 계층(ViewModel)에서 처리할 수 있도록 함
        }
    }
}


