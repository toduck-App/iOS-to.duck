import Foundation

public enum UserAuthAPI {
    case changePassword(loginId: String, changedPassword: String, phoneNumber: String) // 비밀번호 변경
    case findId(phoneNumber: String) // 아이디 찾기
    case requestVerificationCodeWithFindId(phoneNumber: String) // 아이디 찾기 인증요청
    case requestVerificationCodeWithFindPassword(loginId: String, phoneNumber: String) // 비밀번호 찾기 인증요청
    case logout(authorization: String, refreshToken: String) // 로그아웃
    // 인증번호 유효성은 AuthAPI
}

extension UserAuthAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .changePassword:
            return "v1/users/find/change-password"
        case .findId:
            return "v1/users/find/login-id"
        case .requestVerificationCodeWithFindId:
            return "v1/users/find/verified-code"
        case .requestVerificationCodeWithFindPassword:
            return "v1/users/find/verify-login-id-phonenumber"
        case .logout:
            return "v1/users/logout"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .changePassword:
            return .put
        case .findId,
                .requestVerificationCodeWithFindId,
                .logout:
            return .get
        case .requestVerificationCodeWithFindPassword:
            return .patch
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .findId(let phoneNumber):
            return ["phoneNumber": phoneNumber]
        case .requestVerificationCodeWithFindId(let phoneNumber):
            return ["phoneNumber": phoneNumber]
        case .changePassword,
                .requestVerificationCodeWithFindPassword,
                .logout:
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .changePassword(let loginId, let changedPassword, let phoneNumber):
            return .requestParameters(
                parameters: ["loginId": loginId,
                             "changedPassword": changedPassword,
                             "phoneNumber": phoneNumber]
            )
        case .requestVerificationCodeWithFindPassword(let loginId, let phoneNumber):
            return .requestParameters(
                parameters: ["loginId": loginId,
                             "phoneNumber": phoneNumber]
            )
        case .findId,
                .requestVerificationCodeWithFindId,
                .logout:
            return .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .logout(let authorization, let refreshToken):
            let cookieHeaderValue = "refreshToken=\(refreshToken)"
            let headers: MFHeaders = [
                .authorization(bearerToken: authorization),
                .cookie(cookieHeaderValue),
                .accept("application/json")
            ]
            return headers
            
        case .changePassword,
                .findId,
                .requestVerificationCodeWithFindId,
                .requestVerificationCodeWithFindPassword:
            return [.contentType("application/json")]
        }
    }
}
