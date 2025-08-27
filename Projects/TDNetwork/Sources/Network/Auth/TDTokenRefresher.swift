import Foundation
import TDCore
import TDData

/// 인증 토큰 갱신을 안전하게 처리하는 `actor`
///
/// 여러 곳에서 동시에 토큰 갱신을 시도할 때 발생하는 경쟁 상태(Race Condition)를 방지하기 위해 싱글톤으로 사용됩니다.
actor TDTokenRefresher {
    static let shared = TDTokenRefresher()
    
    private var refreshTask: Task<Void, Error>?
    
    private init() { }
    
    func refreshTokens() async throws {
        if let existingTask = refreshTask {
            // 진행 중인 작업이 있다면, 해당 작업이 끝날 때까지 기다립니다.
            try await existingTask.value
            return
        }
        
        let task = Task {
            defer { refreshTask = nil }
            
            let provider = MFProvider<AuthAPI>()
            guard let refreshToken = TDTokenManager.shared.refreshToken else {
                throw MFError.serverError(apiError: .expiredRefreshToken)
            }
            
            let target = AuthAPI.refreshToken(refreshToken: refreshToken)
            
            let response = try await provider.requestDecodable(of: LoginUserResponseBody.self, target)
            
            guard let newRefreshToken = response.extractRefreshToken(),
                  let newRefreshTokenExpiredAt = response.extractRefreshTokenExpiry()
            else {
                throw MFError.requestJSONDecodingFailure
            }
            
            try await TDTokenManager.shared.saveToken((
                accessToken: response.value.accessToken,
                refreshToken: newRefreshToken,
                refreshTokenExpiredAt: newRefreshTokenExpiredAt,
                userId: response.value.userId
            ))
        }
        
        refreshTask = task
        
        try await task.value
    }
}
