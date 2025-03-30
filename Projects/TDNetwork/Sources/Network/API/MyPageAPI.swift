import Foundation

public enum MyPageAPI {
    case fetchNickname
    case changeNickname(nickname: String)
}

extension MyPageAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchNickname,
                .changeNickname:
            return "/v1/my-page/nickname"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchNickname:
            return .get
        case .changeNickname:
            return .patch
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchNickname,
                .changeNickname:
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchNickname:
            return .requestPlain
        case .changeNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname])
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .fetchNickname,
                .changeNickname:
            return [.contentType("application/json")]
        }
    }
}
