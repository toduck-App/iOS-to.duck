import TDCore
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
        try await service.requestOauthRegister(oauthProvider: "KAKAO", oauthId: kakaoAppKey, idToken: idToken)
    }
    
    public func requestAppleLogin(
        oauthId: String,
        idToken: String
    ) async throws -> Result<Void, TDDataError> {
        TDLogger.debug("Repo: \(oauthId), \(idToken)")
        return try await service.requestAppleLogin(oauthId: oauthId, idToken: idToken)
    }
}


