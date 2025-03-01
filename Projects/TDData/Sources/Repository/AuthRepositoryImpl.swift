import TDCore
import TDDomain

public struct AuthRepositoryImpl: AuthRepository {
    private let service: AuthService
    
    public init(service: AuthService) {
        self.service = service
    }
    
    public func requestLogin(
        loginId: String,
        password: String
    ) async throws -> Result<Void, TDDataError> {
        TDLogger.debug("Repo: \(loginId), \(password)")
        return try await service.requestLogin(loginId: loginId, password: password)
    }
    
    public func requestAppleLogin(
        oauthId: String,
        idToken: String
    ) async throws -> Result<Void, TDDataError> {
        TDLogger.debug("Repo: \(oauthId), \(idToken)")
        return try await service.requestAppleLogin(oauthId: oauthId, idToken: idToken)
    }
}
