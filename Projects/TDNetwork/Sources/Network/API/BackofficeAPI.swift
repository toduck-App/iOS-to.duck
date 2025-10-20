import Foundation
import TDCore

public enum BackofficeAPI {
    case validateVersion(version: String)
}

extension BackofficeAPI: MFTarget {
    public var baseURL: URL {
        switch self {
        case .validateVersion:
            URL(string: APIConstants.baseURL)!
        }
    }
    
    public var path: String {
        switch self {
        case .validateVersion:
            "/v1/backoffice/app/version-check"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .validateVersion:
            .get
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .validateVersion(let version):
            ["platform": "iOS", "version": version]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .validateVersion(let version):
            .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .validateVersion: [
                .contentType("application/json"),
            ]
        }
    }
}
