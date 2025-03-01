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
        let result = try await service.requestLogin(loginId: loginId, password: password)
        
        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func requestAppleLogin(
        oauthId: String,
        idToken: String
    ) async throws -> Result<Void, TDDataError> {
        TDLogger.debug("Repo: \(oauthId), \(idToken)")
        return try await service.requestAppleLogin(oauthId: oauthId, idToken: idToken)
    }
}
