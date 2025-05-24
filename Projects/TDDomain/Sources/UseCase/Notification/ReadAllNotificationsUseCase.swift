public protocol ReadAllNotificationsUseCase {
    func execute() async throws
}

public final class ReadAllNotificationsUseCaseImpl: ReadAllNotificationsUseCase {
    private let repository: NotificationRepository
    
    public init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    public func execute() async throws {
        try await repository.readAllNotifications()
    }
}
