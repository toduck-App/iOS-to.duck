import TDCore
import AuthenticationServices

public protocol AuthRepository {
    func requestAppleLogin(oauthId: String, idToken: String) async throws -> Result<Void, TDDataError>
}
