import TDData

public struct UserAuthServiceImpl: UserAuthService {
    private let provider: MFProvider<UserAuthAPI>
    
    public init(provider: MFProvider<UserAuthAPI> = MFProvider<UserAuthAPI>()) {
        self.provider = provider
    }
    
    public func requestFindIdVerificationCode(phoneNumber: String) async throws {
        let target = UserAuthAPI.requestVerificationCodeWithFindId(phoneNumber: phoneNumber)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func findId(phoneNumber: String) async throws -> String {
        let target = UserAuthAPI.findId(phoneNumber: phoneNumber)
        let response = try await provider.requestDecodable(of: FindIdResponseDTO.self, target)
        
        return response.value.loginId
    }
    
    public func requestFindPasswordVerificationCode(loginId: String, phoneNumber: String) async throws {
        let target = UserAuthAPI.requestVerificationCodeWithFindPassword(loginId: loginId, phoneNumber: phoneNumber)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func changePassword(loginId: String, changedPassword: String, phoneNumber: String) async throws {
        let target = UserAuthAPI.changePassword(loginId: loginId, changedPassword: changedPassword, phoneNumber: phoneNumber)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
}
