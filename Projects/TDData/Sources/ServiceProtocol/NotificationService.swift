import TDCore
import TDDomain

public protocol NotificationService {
    func fetchNotifications(page: Int, size: Int) async throws -> NotificationResponseDTO
    func registerDeviceToken(token: String) async throws
    func deleteDeviceToken(token: String) async throws
    func readNotification(notificationId: Int) async throws
    func readAllNotifications() async throws
}
