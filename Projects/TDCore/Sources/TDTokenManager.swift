import Foundation
import KeyChainManager_KJ

public final class TDTokenManager {
    public static let shared = TDTokenManager()
    public private(set) var accessToken: String?
    public private(set) var refreshToken: String?
    public private(set) var refreshTokenExpiredAt: Date?
    public private(set) var userId: Int?
       
    private init() {}
    
    public func loadTokenFromKC() async throws {
        guard let accessToken = try await KeyChainManagerWithActor.shared.loadString(account: KeyChainConstant.accessToken.rawValue),
              let refreshToken = try await KeyChainManagerWithActor.shared.loadString(account: KeyChainConstant.refreshToken.rawValue),
              let refreshTokenExpiredAtString = try await KeyChainManagerWithActor.shared.loadString(account: KeyChainConstant.refreshTokenExpiredAt.rawValue),
              let userIdData = try await KeyChainManagerWithActor.shared.loadString(account: KeyChainConstant.userId.rawValue),
              let userId = Int(userIdData)
        else {
            throw TDDataError.notFoundToken
        }
        
        guard let refreshTokenExpiredAt = convertToDate(refreshTokenExpiredAtString), Date() < refreshTokenExpiredAt else {
            try await removeToken()
            throw TDDataError.expiredRefreshToken
        }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.refreshTokenExpiredAt = refreshTokenExpiredAt
        self.userId = userId
    }
    
    // 1. AccessToken이 만료되어 RefreshToken을 사용해 Token정보를 갱신할 때 사용
    // 2. 로그인 성공할 때 사용
    public func saveToken(
        _ token: (
            accessToken: String,
            refreshToken: String,
            refreshTokenExpiredAt: String,
            userId: Int
        )
    ) async throws {
        try await KeyChainManagerWithActor.shared.save(string: token.accessToken, account: KeyChainConstant.accessToken.rawValue)
        try await KeyChainManagerWithActor.shared.save(string: token.refreshToken, account: KeyChainConstant.refreshToken.rawValue)
        try await KeyChainManagerWithActor.shared.save(string: token.refreshTokenExpiredAt, account: KeyChainConstant.refreshTokenExpiredAt.rawValue)
        let saveUserIdData = try JSONEncoder().encode(token.userId)
        try await KeyChainManagerWithActor.shared.save(with: saveUserIdData, account: KeyChainConstant.userId.rawValue)
        
        accessToken = token.accessToken
        refreshToken = token.refreshToken
        refreshTokenExpiredAt = convertToDate(token.refreshTokenExpiredAt)
        userId = token.userId
    }
    
    public func removeToken() async throws {
        accessToken = nil
        refreshToken = nil
        refreshTokenExpiredAt = nil
        userId = nil
        
        try await KeyChainManagerWithActor.shared.delete(account: KeyChainConstant.accessToken.rawValue)
        try await KeyChainManagerWithActor.shared.delete(account: KeyChainConstant.refreshToken.rawValue)
        try await KeyChainManagerWithActor.shared.delete(account: KeyChainConstant.refreshTokenExpiredAt.rawValue)
        try await KeyChainManagerWithActor.shared.delete(account: KeyChainConstant.userId.rawValue)
    }
    
    private func convertToDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter.date(from: string)
    }
}
