public protocol UserAuthService {
    func requestFindIdVerificationCode(phoneNumber: String) async throws
    func findId(phoneNumber: String) async throws -> String
    func requestFindPasswordVerificationCode(loginId: String, phoneNumber: String) async throws
}
