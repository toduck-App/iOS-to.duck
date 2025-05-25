import TDCore

public protocol NotificationRepository {
    func fetchNotifications(page: Int, size: Int) async throws -> TDNotificationList
    func registerDeviceToken(token: String) async throws
    func deleteDeviceToken(token: String) async throws
    func readNotification(notificationId: Int) async throws
    func readAllNotifications() async throws
}
