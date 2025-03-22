import Foundation

public struct LoginUserResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let refreshTokenExpiredAt: String
    public let userId: Int
    
    public init(
        accessToken: String,
        refreshToken: String,
        refreshTokenExpiredAt: String,
        userId: Int
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.refreshTokenExpiredAt = refreshTokenExpiredAt
        self.userId = userId
    }
}

public struct LoginUserResponseBody: Decodable {
    public let accessToken: String
    public let userId: Int
}
