import Foundation
import TDCore
@testable import TDDomain

public final class MockNotificationRepository: NotificationRepository {
    // MARK: - Stubbed Outputs
    public var stubbedNotificationList: TDNotificationList = TDNotificationList(notifications: [])
    public var didRegisterDeviceToken: String?
    public var didDeleteDeviceToken: String?
    public var didReadNotificationId: Int?
    public var didCallReadAllNotifications = false

    // MARK: - Init
    public init() {}

    // MARK: - NotificationRepository Methods

    public func fetchNotifications(page: Int, size: Int) async throws -> TDNotificationList {
        return stubbedNotificationList
    }

    public func registerDeviceToken(token: String) async throws {
        didRegisterDeviceToken = token
    }

    public func deleteDeviceToken(token: String) async throws {
        didDeleteDeviceToken = token
    }

    public func readNotification(notificationId: Int) async throws {
        didReadNotificationId = notificationId
    }

    public func readAllNotifications() async throws {
        didCallReadAllNotifications = true
    }
}
