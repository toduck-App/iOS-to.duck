import TDCore
import TDDomain

public protocol AuthService {
    func requestRegisterUser(phoneNumber: String, loginId: String, password: String) async throws
    func requestPhoneVerification(with phoneNumber: String) async throws
    func checkPhoneVerification(phoneNumber: String, verifiedCode: String) async throws
    func checkDuplicateUserID(loginId: String) async throws
    func requestOauthRegister(oauthProvider: String, oauthId: String, idToken: String) async throws -> LoginUserResponseDTO
    func requestKakaoLogin() async throws -> String
    func requestLogin(loginId: String, password: String) async throws -> LoginUserResponseDTO
    func refreshToken() async throws -> LoginUserResponseDTO
}
