import TDCore

public protocol AuthService {
    func requestAppleLogin(oauthId: String, idToken: String) async throws -> Result<Void, TDDataError>
}
