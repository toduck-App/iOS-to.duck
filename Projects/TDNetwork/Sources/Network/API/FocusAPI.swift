import Foundation
import TDData
import TDCore
import TDDomain

public enum FocusAPI {
    case saveFocus(date: String, targetCount: Int, settingCount: Int, time: Int)
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
        case .saveFocus:
            return "/v1/concentration/save"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchFocusPercent,
                .fetchFocusList:
            return .get
        case .saveFocus:
            return .post
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
        case .saveFocus:
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchFocusPercent,
                .fetchFocusList:
            return .requestPlain
        case .saveFocus(let date, let targetCount, let settingCount, let time):
            return .requestParameters(parameters: [
                "date": date,
                "targetCount": targetCount,
                "settingCount": settingCount,
                "time": time
            ])
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
