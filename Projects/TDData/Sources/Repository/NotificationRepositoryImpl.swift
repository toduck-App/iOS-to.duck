import TDDomain

public struct NotificationRepositoryImpl: NotificationRepository {
    
    private let service: NotificationService
    
    public init(service: NotificationService) {
        self.service = service
    }
    
    public func fetchNotifications(page: Int, size: Int) async throws -> TDNotificationList {
        let response = try await service.fetchNotifications(page: page, size: size)
        return response.convertToTDNotification()
    }
    
    public func registerDeviceToken(token: String) async throws {
        try await service.registerDeviceToken(token: token)
    }
    
    public func deleteDeviceToken(token: String) async throws {
        try await service.deleteDeviceToken(token: token)
    }
    
    public func readNotification(notificationId: Int) async throws {
        try await service.readNotification(notificationId: notificationId)
    }
    
    public func readAllNotifications() async throws {
        try await service.readAllNotifications()
    }
}
