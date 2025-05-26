import Foundation
import TDCore

public enum MyPageAPI {
    case fetchNickname
    case updateNickname(nickname: String)
    case updateProfileImage(urlString: String?)
}

extension MyPageAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchNickname,
             .updateNickname:
            "/v1/my-page/nickname"
        case .updateProfileImage:
            "/v1/my-page/profile-image"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchNickname:
            .get
        case .updateNickname,
             .updateProfileImage:
            .patch
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchNickname,
             .updateNickname,
             .updateProfileImage:
            nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchNickname:
            .requestPlain
        case .updateNickname(let nickname):
            .requestParameters(parameters: ["nickname": nickname])
        case .updateProfileImage(let urlString):
            .requestParameters(parameters: ["imageUrl": urlString])
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .fetchNickname,
             .updateNickname,
             .updateProfileImage:
            [.contentType("application/json"),
             .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")]
        }
    }
}
