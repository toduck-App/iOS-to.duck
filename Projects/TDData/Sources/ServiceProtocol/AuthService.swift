import TDCore
import TDDomain

public protocol AuthService {
    func requestOauthRegister(oauthProvider: String, oauthId: String, idToken: String) async throws
    func requestKakaoLogin() async throws -> String
}
