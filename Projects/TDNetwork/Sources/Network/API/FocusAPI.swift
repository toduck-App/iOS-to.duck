import Foundation
import TDData
import TDCore
import TDDomain

public enum FocusAPI {
    case fetchFocusPercent(yearMonth: String)
    case fetchDiaryList(yearMonth: String)
}

extension FocusAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchFocusPercent:
            return "v1/concentration/percent"
        case .fetchDiaryList:
            return "v1/concentration/monthly"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchFocusPercent,
                .fetchDiaryList:
            return .get
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchFocusPercent(let yearMonth):
            return [
                "yearMonth": yearMonth
            ]
        case .fetchDiaryList(let yearMonth):
            return [
                "yearMonth": yearMonth
            ]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchFocusPercent,
                .fetchDiaryList:
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
