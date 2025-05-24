public protocol FetchNotificationListUseCase {
    func execute(page: Int, size: Int) async throws -> TDNotificationList
}

public final class FetchNotificationListUseCaseImpl: FetchNotificationListUseCase {
    private let repository: NotificationRepository
    
    public init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    public func execute(page: Int, size: Int) async throws -> TDNotificationList {
        return try await repository.fetchNotifications(page: page, size: size)
    }
}
