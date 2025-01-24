//
//  AuthAPI.swift
//  TDNetwork
//
//  Created by 디해 on 1/22/25.
//

import Foundation

public enum AuthAPI {
    case requestPhoneVerification(phoneNumber: String) // 휴대폰 본인 인증 요청
    case checkPhoneVerification(code: String) // 휴대폰 본인 인증 확인
    case checkUsernameDuplication(username: String) // 아이디 중복 확인
    case registerUser(userDetails: [String: Any]) // 회원가입
    case login(username: String, password: String) // 자체 로그인
    case loginApple(token: String) // 애플 로그인
    case loginKakao(token: String) // 카카오 로그인
    case loginNaver(token: String) // 네이버 로그인
    case loginGoogle(token: String) // 구글 로그인
    case findIdPassword(phoneNumber: String) // 비밀번호 찾기
    case refreshToken(refreshToken: String) // 리프래시 토큰 발급
    case saveFCMToken(userId: Int, fcmToken:String) // FCM 토큰 저장
    case deleteUser(userId: Int) // 유저 삭제
}

extension AuthAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .requestPhoneVerification:
            return "/auth/request-phone-verification"
        case .checkPhoneVerification:
            return "/auth/check-phone-verification"
        case .checkUsernameDuplication:
            return "/auth/check-username-duplication"
        case .registerUser:
            return "/auth/registerUser"
        case .login:
            return "/auth/login"
        case .loginApple:
            return "/auth/oauth/apple"
        case .loginKakao:
            return "/auth/oauth/kakao"
        case .loginNaver:
            return "/auth/oauth/naver"
        case .loginGoogle:
            return "/auth/oauth/google"
        case .findIdPassword:
            return "/auth/find-id-password"
        case .refreshToken:
            return "/auth/refresh-token"
        case .saveFCMToken(let userId, _):
            return "/users/\(userId)/fcm-token"
        case .deleteUser(let userId):
            return "/users/\(userId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .refreshToken:
            return .get
        case .requestPhoneVerification,
             .checkPhoneVerification,
             .checkUsernameDuplication,
             .registerUser,
             .login,
             .loginApple,
             .loginKakao,
             .loginNaver,
             .loginGoogle,
             .findIdPassword,
             .saveFCMToken:
            return .post
        case .deleteUser:
            return .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .refreshToken(let refreshToken):
            return ["refreshToken": refreshToken]
        case .requestPhoneVerification,
             .checkPhoneVerification,
             .checkUsernameDuplication,
             .registerUser,
             .login,
             .loginApple,
             .loginKakao,
             .loginNaver,
             .loginGoogle,
             .findIdPassword,
             .saveFCMToken:
            return nil
        case .deleteUser(let userId):
            // TODO: - 나중 결정?
            return [:]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .requestPhoneVerification(let phoneNumber):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber]
            )
            
        case .checkPhoneVerification(let code):
            return .requestParameters(
                parameters: ["code": code]
            )
            
        case .checkUsernameDuplication(let username):
            return .requestParameters(
                parameters: ["username": username]
            )
            
        case .registerUser(let userDetails):
            return .requestParameters(parameters: userDetails)
            
        case .login(let username, let password):
            return .requestParameters(
                parameters: ["username": username,
                             "password": password]
            )
            
        case .loginApple(let token), .loginKakao(let token), .loginNaver(let token), .loginGoogle(let token):
            return .requestParameters(
                parameters: ["token": token]
            )
            
        case .findIdPassword(let phoneNumber):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber]
            )
            
        case .saveFCMToken(_, let fcmToken):
            return .requestParameters(
                parameters: ["fcmToken": fcmToken]
            )
            
        case .deleteUser, .refreshToken:
            return .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .requestPhoneVerification,
             .checkPhoneVerification,
             .checkUsernameDuplication,
             .registerUser,
             .login,
             .loginApple,
             .loginKakao,
             .loginNaver,
             .loginGoogle,
             .findIdPassword:
            let jsonHeaders: MFHeaders = [.contentType("application/json")]
            return jsonHeaders
            
        case .refreshToken,
             .saveFCMToken,
             .deleteUser:
            // TODO: - saveFCMToken도 Content-Type을 지정해야 할 것 같습니다.
            return nil
        }
    }
}
