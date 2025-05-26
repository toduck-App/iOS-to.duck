import Foundation
import TDCore

public enum UserAuthAPI {
    case changePassword(loginId: String, changedPassword: String, phoneNumber: String) // 비밀번호 변경
    case findId(phoneNumber: String) // 아이디 찾기
    case requestVerificationCodeWithFindId(phoneNumber: String) // 아이디 찾기 인증요청
    case requestVerificationCodeWithFindPassword(loginId: String, phoneNumber: String) // 비밀번호 찾기 인증요청
    case logout // 로그아웃
    case withdraw(reasonCode: String, reasonText: String)
    // 인증번호 유효성은 AuthAPI
}

extension UserAuthAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .changePassword:
            "v1/users/find/change-password"
        case .findId:
            "v1/users/find/login-id"
        case .requestVerificationCodeWithFindId:
            "v1/users/find/verified-code"
        case .requestVerificationCodeWithFindPassword:
            "v1/users/find/verify-login-id-phonenumber"
        case .logout:
            "v1/users/logout"
        case .withdraw:
            "v1/my-page/account"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .changePassword:
            .put
        case .findId,
             .requestVerificationCodeWithFindId,
             .logout:
            .get
        case .requestVerificationCodeWithFindPassword:
            .patch
        case .withdraw:
            .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .findId(let phoneNumber):
            ["phoneNumber": phoneNumber]
        case .requestVerificationCodeWithFindId(let phoneNumber):
            ["phoneNumber": phoneNumber]
        case .changePassword,
             .requestVerificationCodeWithFindPassword,
             .logout,
             .withdraw:
            nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .changePassword(let loginId, let changedPassword, let phoneNumber):
            .requestParameters(
                parameters: ["loginId": loginId,
                             "changedPassword": changedPassword,
                             "phoneNumber": phoneNumber]
            )
        case .requestVerificationCodeWithFindPassword(let loginId, let phoneNumber):
            .requestParameters(
                parameters: ["loginId": loginId,
                             "phoneNumber": phoneNumber]
            )
        case .withdraw(let reasonCode, let reasonText):
            .requestParameters(
                parameters: ["reasonCode": reasonCode,
                             "reasonText": reasonText]
            )
        case .findId,
             .requestVerificationCodeWithFindId,
             .logout:
            .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .logout, .withdraw:
            let headers: MFHeaders = [
                .authorization(bearerToken: TDTokenManager.shared.accessToken ?? ""),
                .cookie(TDTokenManager.shared.refreshToken ?? ""),
                .contentType("application/json"),
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
