import TDCore
import Foundation
import TDData

public struct AuthServiceImpl: AuthService {
    private let provider: MFProvider<AuthAPI>
    
    public init(provider: MFProvider<AuthAPI> = MFProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    public func requestLogin(
        loginId: String,
        password: String
    ) async throws -> LoginUserResponseDTO {
        let response = try await provider.request(.login(userLoginId: loginId, password: password))

        if let httpResponse = response.httpResponse {
            let statusCode = httpResponse.statusCode
            let headers = httpResponse.allHeaderFields
            
            switch statusCode {
            case 200:
                let refreshToken = extractRefreshToken(from: headers) ?? ""
                let refreshTokenExpiredAt = extractRefreshTokenExpiry(from: headers) ?? ""

                do {
                    let loginResponse = try LoginUserResponseDTO.from(
                        bodyData: response.value,
                        refreshToken: refreshToken,
                        refreshTokenExpiredAt: refreshTokenExpiredAt
                    )
                    TDLogger.info("로그인 성공: \(loginResponse)")
                    return loginResponse
                } catch {
                    TDLogger.error("파싱 오류: \(error.localizedDescription)")
                    throw TDDataError.parsingError
                }
            case 401:
                TDLogger.error("[로그인 실패]: 아이디 또는 비밀번호가 잘못됨")
                throw TDDataError.invalidIDOrPassword
            case 500..<600:
                TDLogger.error("[로그인 실패]: 서버 에러")
                throw TDDataError.serverError
            default:
                throw TDDataError.generalFailure
            }
        }
        
        throw TDDataError.requestLoginFailure
    }
    
    private func extractRefreshToken(from headers: [AnyHashable: Any]) -> String? {
        guard let setCookie = headers["Set-Cookie"] as? String else { return nil }

        let components = setCookie.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        for component in components {
            if component.hasPrefix("refreshToken=") {
                return component.replacingOccurrences(of: "refreshToken=", with: "")
            }
        }
        return nil
    }
    
    private func extractRefreshTokenExpiry(from headers: [AnyHashable: Any]) -> String? {
        guard let setCookie = headers["Set-Cookie"] as? String else { return nil }
        
        let components = setCookie.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        for component in components {
            if component.hasPrefix("Expires=") {
                return component.replacingOccurrences(of: "Expires=", with: "")
            }
        }
        return nil
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
