public protocol ReadNotificationUseCase {
    func execute(notificationId: Int) async throws
}

public final class ReadNotificationUseCaseImpl: ReadNotificationUseCase {
    private let repository: NotificationRepository
    
    public init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    public func execute(notificationId: Int) async throws {
        try await repository.readNotification(notificationId: notificationId)
    }
}
