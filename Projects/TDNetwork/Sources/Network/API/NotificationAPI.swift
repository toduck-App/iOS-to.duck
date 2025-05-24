import Foundation
import TDCore

public enum NotificationAPI {
    case fetchNotifications(page: Int, size: Int) // 알림 목록 조회
    case registerDeviceToken(token: String) // 디바이스 토큰 등록
    case deleteDeviceToken(token: String) // 디바이스 토큰 삭제
    case readNotification(notificationId: Int) // 알림 읽음 처리
    case readAllNotifications // 모든 알림 읽음 처리
//    case fetchAlarmSettings // 알림 설정 조회
//    case updateAlarmSettings(settings: [String: Any]) // 알림 설정 업데이트
}

extension NotificationAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchNotifications:
            return "/v1/notifications"
        case .registerDeviceToken:
            return "/v1/notifications/device-tokens"
        case .deleteDeviceToken(let token):
            return "/v1/notifications/device-tokens/\(token)"
        case .readNotification(let notificationId):
            return "/v1/notifications/\(notificationId)"
        case .readAllNotifications:
            return "/v1/notifications/read-all"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchNotifications:
                .get
        case .registerDeviceToken:
            .post
        case .readNotification,
                .readAllNotifications:
            .patch
        case .deleteDeviceToken:
            .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchNotifications(let page, let size):
            return ["page": page, "size": size]
        case .readNotification(let notificationId):
            return ["notificationId": notificationId]
        case .deleteDeviceToken(let token):
            return ["token": token]
        case .registerDeviceToken,
                .readAllNotifications:
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchNotifications,
                .readNotification,
                .readAllNotifications,
                .deleteDeviceToken:
            return .requestPlain
        case .registerDeviceToken(let token):
            return .requestJSONEncodable(token)
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
            case .fetchNotifications,
                    .registerDeviceToken,
                    .deleteDeviceToken,
                    .readNotification,
                    .readAllNotifications:
            let headers: MFHeaders = [
                .contentType("application/json"),
                .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
            ]
            return headers
        }
    }
}
