import TDCore
import AuthenticationServices

public protocol AuthRepository {
    func requestKakaoLogin() async throws
    func requestAppleLogin(oauthId: String, idToken: String) async throws -> Result<Void, TDDataError>
}
