import TDCore
import TDData

public final class AuthServiceImpl: AuthService {
    private let provider: MFProvider<AuthAPI>
    
    public init(provider: MFProvider<AuthAPI> = MFProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    public func requestAppleLogin(
        oauthId: String,
        idToken: String
    ) async throws -> Result<Void, TDDataError> {
        let response = try await provider.request(.loginApple(oauthId: oauthId, idToken: idToken))
        
        if let statusCode = response.httpResponse?.statusCode {
            switch statusCode {
            case 200..<300:
                TDLogger.info("애플 로그인 요청 성공")
                return .success(())
            case 403:
                TDLogger.error("[애플 로그인 실패]: IDToken 잘못됨")
                return .failure(.invalidIDToken)
            case 404:
                TDLogger.error("[애플 로그인 실패]: 공개키 잘못됨")
                return .failure(.notFoundPulbicKey)
            case 500..<600:
                TDLogger.error("[애플 로그인 실패]: 서버 에러")
                return .failure(.serverError)
            default:
                return .failure(.generalFailure)
            }
        }
        
        return .failure(.requestLoginFailure)
    }
}
