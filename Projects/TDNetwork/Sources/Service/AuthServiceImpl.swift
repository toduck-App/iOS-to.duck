import TDCore
import TDDomain
import TDData
import Foundation
import KakaoSDKUser

public struct AuthServiceImpl: AuthService {
    private let provider: MFProvider<AuthAPI>
    
    public init(provider: MFProvider<AuthAPI> = MFProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    public func requestOauthRegister(oauthProvider: String, oauthId: String, idToken: String) async throws {
        let response = try await provider.request(.loginOauth(provider: oauthProvider, oauthId: oauthId, idToken: idToken))
    }
    
    public func requestLogin(
        loginId: String,
        password: String
    ) async throws -> LoginUserResponseDTO {
        let response = try await provider.request(.login(loginId: loginId, password: password))

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
    
    public func requestKakaoLogin() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            TDLogger.info("[AuthServiceImpl] 카카오톡 앱으로 로그인 인증")
            return try await handleKakaoLoginWithApp()
        } else {
            TDLogger.info("[AuthServiceImpl] 카톡이 설치가 안 되어 웹뷰 실행")
            return try await handleKakaoLoginWithAccount()
        }
    }
    
    private func handleKakaoLoginWithApp() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let idToken = oauthToken?.idToken else {
                    continuation.resume(throwing: TDDataError.invalidIDToken)
                    return
                }
                
                continuation.resume(returning: idToken)
            }
        }
    }
    
    private func handleKakaoLoginWithAccount() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let idToken = oauthToken?.idToken else {
                    continuation.resume(throwing: TDDataError.invalidIDToken)
                    return
                }
                continuation.resume(returning: idToken)
            }
        }
    }
}
