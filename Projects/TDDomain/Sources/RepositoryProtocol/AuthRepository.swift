import TDCore
import AuthenticationServices

public protocol AuthRepository {
    func requestLogin(loginId: String, password: String) async throws
    func requestAppleLogin(oauthId: String, idToken: String) async throws -> Result<Void, TDDataError>
}
