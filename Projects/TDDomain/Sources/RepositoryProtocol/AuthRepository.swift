import TDCore
import AuthenticationServices

public protocol AuthRepository {
    func requestRegisterUser(user: RegisterUser) async throws
    func requestPhoneVerification(with phoneNumber: String) async throws
    func checkPhoneVerification(phoneNumber: String, verifiedCode: String) async throws
    func checkDuplicateUserID(loginId: String) async throws
    func requestKakaoLogin() async throws
    func requestAppleLogin(oauthId: String, idToken: String) async throws
    func requestLogin(loginId: String, password: String) async throws
    func refreshToken() async throws
}
