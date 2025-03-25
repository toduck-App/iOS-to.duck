import TDCore
import TDDomain

public protocol AuthService {
    func requestOauthRegister(oauthProvider: String, oauthId: String, idToken: String) async throws -> LoginUserResponseDTO
    func requestKakaoLogin() async throws -> String
    func requestLogin(loginId: String, password: String) async throws -> LoginUserResponseDTO
    func refreshToken() async throws -> LoginUserResponseDTO
}
