import TDCore
import TDDomain

public struct UserAuthRepositoryImpl: UserAuthRepository {
    private let service: UserAuthService
    
    public init(service: UserAuthService) {
        self.service = service
    }
    
    public func requestFindIdVerificationCode(phoneNumber: String) async throws {
        try await service.requestFindIdVerificationCode(phoneNumber: phoneNumber)
    }
    
    public func findId(phoneNumber: String) async throws -> String {
        try await service.findId(phoneNumber: phoneNumber)
    }
    
    public func requestFindPasswordVerificationCode(loginId: String, phoneNumber: String) async throws {
        try await service.requestFindPasswordVerificationCode(loginId: loginId, phoneNumber: phoneNumber)
    }
    
    public func changePassword(loginId: String, changedPassword: String, phoneNumber: String) async throws {
        try await service.changePassword(loginId: loginId, changedPassword: changedPassword, phoneNumber: phoneNumber)
    }
    
    public func logout() async throws {
        try await service.logout()
        try await TDTokenManager.shared.removeToken()
    }
}
