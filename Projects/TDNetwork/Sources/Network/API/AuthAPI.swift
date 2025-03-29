import Foundation

public enum AuthAPI {
    case requestPhoneVerification(phoneNumber: String) // 휴대폰 본인 인증 요청
    case checkPhoneVerification(phoneNumber: String, code: String) // 휴대폰 본인 인증 확인
    case checkUsernameDuplication(username: String) // 아이디 중복 확인
    case registerUser(userDetails: [String: Any]) // 회원가입
    case login(loginId: String, password: String) // 자체 로그인
    case loginOauth(provider: String, oauthId: String, idToken: String) // Oauth 로그인
    case findIdPassword(phoneNumber: String) // 비밀번호 찾기
    case refreshToken(refreshToken: String) // 리프래시 토큰 발급
    case saveFCMToken(userId: Int, fcmToken: String) // FCM 토큰 저장
    case deleteUser(userId: Int) // 유저 삭제
}

extension AuthAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .requestPhoneVerification:
            return "v1/auth/verified-code"
        case .checkPhoneVerification:
            return "v1/auth/check-verfied-code"
        case .checkUsernameDuplication:
            return "/auth/check-username-duplication"
        case .registerUser:
            return "/auth/registerUser"
        case .login:
            return "/v1/auth/login"
        case .loginOauth:
            return "/v1/auth/oauth/register"
        case .findIdPassword:
            return "/auth/find-id-password"
        case .refreshToken:
            return "/v1/auth/refresh"
        case .saveFCMToken(let userId, _):
            return "/users/\(userId)/fcm-token"
        case .deleteUser(let userId):
            return "/users/\(userId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .requestPhoneVerification,
                .refreshToken,
                .checkPhoneVerification:
            return .get
        case .checkUsernameDuplication,
                .registerUser,
                .login,
                .loginOauth,
                .findIdPassword,
                .saveFCMToken:
            return .post
        case .deleteUser:
            return .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .requestPhoneVerification(let phoneNumber):
            return ["phoneNumber": phoneNumber]
        case .checkPhoneVerification(let phoneNumber, let code):
            return [
                "phoneNumber": phoneNumber,
                "code": code
            ]
        case .loginOauth(let provider, _, _):
            return ["provider": provider]
        case .checkUsernameDuplication,
                .registerUser,
                .login,
                .findIdPassword,
                .saveFCMToken,
                .refreshToken:
            return nil
        case .deleteUser(let userId):
            // TODO: - 나중 결정?
            return [:]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .checkUsernameDuplication(let username):
            return .requestParameters(
                parameters: ["username": username]
            )
            
        case .registerUser(let userDetails):
            return .requestParameters(parameters: userDetails)
            
        case .login(let loginId, let password):
            return .requestParameters(
                parameters: ["loginId": loginId,
                             "password": password]
            )
            
        case .loginOauth(_, let oauthId, let idToken):
            return .requestParameters(
                parameters: [
                    "oauthId": oauthId,
                    "idToken": idToken,
                    "nonce": "nonce"
                ]
            )
            
        case .findIdPassword(let phoneNumber):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber]
            )
            
        case .saveFCMToken(_, let fcmToken):
            return .requestParameters(
                parameters: ["fcmToken": fcmToken]
            )
            
        case .requestPhoneVerification,
                .checkPhoneVerification,
                .deleteUser,
                .refreshToken:
            return .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .checkPhoneVerification,
                .checkUsernameDuplication,
                .registerUser,
                .login,
                .loginOauth,
                .findIdPassword:
            let jsonHeaders: MFHeaders = [.contentType("application/json")]
            return jsonHeaders
        case .refreshToken(let refreshToken):
            let cookieHeaderValue = "refreshToken=\(refreshToken)"
            let headers: MFHeaders = [.cookie(cookieHeaderValue), .accept("application/json")]
            return headers
        case .requestPhoneVerification,
                .saveFCMToken,
                .deleteUser:
            return nil
        }
    }
    
}
