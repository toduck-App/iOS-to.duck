import Foundation
import TDCore
import TDData
import TDDomain

public struct NotificationServiceImpl: NotificationService {
    private let provider: MFProvider<NotificationAPI>
    
    public init(provider: MFProvider<NotificationAPI> = MFProvider<NotificationAPI>()) {
        self.provider = provider
    }
    
    public func registerDeviceToken(token: String) async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .registerDeviceToken(token: token))
    }
    
    public func fetchNotifications(page: Int, size: Int) async throws -> NotificationResponseDTO {
        let response = try await provider.requestDecodable(of: NotificationResponseDTO.self, .fetchNotifications(page: page, size: size))
        return response.value
    }
    
    public func deleteDeviceToken(token: String) async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .deleteDeviceToken(token: token))
    }
    
    public func readNotification(notificationId: Int) async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .readNotification(notificationId: notificationId))
    }
    
    public func readAllNotifications() async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .readAllNotifications)
    }
}
