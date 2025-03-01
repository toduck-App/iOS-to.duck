import TDCore

public protocol AuthService {
    func requestLogin(loginId: String, password: String) async throws -> Result<Void, TDDataError>
    func requestAppleLogin(oauthId: String, idToken: String) async throws -> Result<Void, TDDataError>
}
