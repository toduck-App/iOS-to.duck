import Foundation

public enum MyPageAPI {
    case fetchNickname
    case updateNickname(nickname: String)
}

extension MyPageAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchNickname,
                .updateNickname:
            return "/v1/my-page/nickname"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchNickname:
            return .get
        case .updateNickname:
            return .patch
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchNickname,
                .updateNickname:
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchNickname:
            return .requestPlain
        case .updateNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname])
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .fetchNickname,
                .updateNickname:
            return [.contentType("application/json")]
        }
    }
}
