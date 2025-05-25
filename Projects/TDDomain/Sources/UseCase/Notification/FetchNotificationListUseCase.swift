import TDCore

public protocol FetchNotificationListUseCase {
    func execute(page: Int, size: Int) async throws -> [TDNotificationDetail]
}

public final class FetchNotificationListUseCaseImpl: FetchNotificationListUseCase {
    private let repository: NotificationRepository
    private let fetchUserUseCase: FetchUserUseCase

    public init(
        repository: NotificationRepository,
        fetchUserUseCase: FetchUserUseCase
    ) {
        self.repository = repository
        self.fetchUserUseCase = fetchUserUseCase
    }

    public func execute(page: Int, size: Int) async throws -> [TDNotificationDetail] {
        var notifications = try await repository.fetchNotifications(page: page, size: size).notifications

        for (index, notification) in notifications.enumerated() {
            guard
                notification.type == "FOLLOW",
                let senderId = notification.senderId
            else { continue }

            do {
                let (_, userDetail) = try await fetchUserUseCase.execute(id: senderId)
                let updated = notification.withIsFollowed(userDetail.isFollowing)
                notifications[index] = updated
            } catch {
                TDLogger.error("Failed to fetch user details for notification: \(error)")
            }
        }

        return notifications
    }
}
