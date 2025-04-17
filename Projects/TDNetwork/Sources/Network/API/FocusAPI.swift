import Foundation
import TDData
import TDCore
import TDDomain

public enum FocusAPI {
    case fetchFocusPercent(yearMonth: String)
    case fetchFocusList(yearMonth: String)
}

extension FocusAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchFocusPercent:
            return "v1/concentration/percent"
        case .fetchFocusList:
            return "v1/concentration/monthly"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchFocusPercent,
                .fetchFocusList:
            return .get
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchFocusPercent(let yearMonth):
            return [
                "yearMonth": yearMonth
            ]
        case .fetchFocusList(let yearMonth):
            return [
                "yearMonth": yearMonth
            ]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchFocusPercent,
                .fetchFocusList:
            return .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        let headers: MFHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
        ]
        return headers
    }
}
