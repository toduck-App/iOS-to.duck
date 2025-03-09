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
    
    public static func from(
        bodyData: Data,
        refreshToken: String,
        refreshTokenExpiredAt: String
    ) throws -> LoginUserResponseDTO {
        let body = try JSONDecoder().decode(LoginUserResponseBody.self, from: bodyData)
        return LoginUserResponseDTO(
            accessToken: body.content.accessToken,
            refreshToken: refreshToken,
            refreshTokenExpiredAt: refreshTokenExpiredAt,
            userId: body.content.userId
        )
    }
}

private struct LoginUserResponseBody: Decodable {
    struct Content: Decodable {
        let accessToken: String
        let userId: Int
    }
    let code: Int
    let content: Content
}
