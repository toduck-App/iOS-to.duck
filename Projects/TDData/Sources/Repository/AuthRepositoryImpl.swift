import TDCore
import TDDomain

public final class AuthRepositoryImpl: AuthRepository {
    private let service: AuthService
    
    public init(service: AuthService) {
        self.service = service
    }
    
    public func requestAppleLogin(
        oauthId: String,
        idToken: String
    ) async throws -> Result<Void, TDDataError> {
        TDLogger.debug("Repo: \(oauthId), \(idToken)")
        return try await service.requestAppleLogin(oauthId: oauthId, idToken: idToken)
    }
}
