public protocol UserAuthRepository {
    func requestFindIdVerificationCode(phoneNumber: String) async throws
    func findId(phoneNumber: String) async throws -> String
    func requestFindPasswordVerificationCode(loginId: String, phoneNumber: String) async throws
    func changePassword(loginId: String, changedPassword: String, phoneNumber: String) async throws
    func withdraw(type: WithdrawReasonType, reason: String) async throws
    func logout() async throws
}
