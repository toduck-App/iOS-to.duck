import Foundation
import TDCore
import TDData
import TDDomain

public enum EventAPI {
    case fetchEvents
    case fetchEventDetails
    case hasParticipated
    case participate(id: Int, phone: String)
}

extension EventAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }

    public var path: String {
        switch self {
        case .fetchEvents:
            "v1/events/get"
        case .fetchEventDetails:
            "v1/events/details/get/"
        case .hasParticipated:
            "v1/events-social/check"
        case .participate:
            "v1/events-social/save"
        }
    }

    public var method: MFHTTPMethod {
        switch self {
        case .fetchEvents:
            .get
        case .fetchEventDetails:
            .get
        case .hasParticipated:
            .get
        case .participate:
            .post
        }
    }

    public var queries: Parameters? {
        switch self {
        case .fetchEvents, .fetchEventDetails, .participate:
            return nil
        case .hasParticipated:
            return ["date": Date().convertToString(formatType: .yearMonthDay)]
        }
    }

    public var task: MFTask {
        switch self {
        case .fetchEvents, .fetchEventDetails, .hasParticipated:
            .requestPlain

        case .participate(let id, let phone):
            .requestParameters(parameters: [
                "socialId": id,
                "phone": phone,
                "date": Date().convertToString(formatType: .yearMonthDay),
            ])
        }
    }

    public var headers: MFHeaders? {
        let headers: MFHeaders = [
            .contentType("application/json"),
            .authorization(
                bearerToken: TDTokenManager.shared.accessToken ?? ""
            ),
        ]
        return headers
    }
}
