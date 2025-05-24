public protocol DeleteDeviceTokenUseCase {
    func execute(token: String) async throws
}

public final class DeleteDeviceTokenUseCaseImpl: DeleteDeviceTokenUseCase {
    private let repository: NotificationRepository
    
    public init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    public func execute(token: String) async throws {
        try await repository.deleteDeviceToken(token: token)
    }
}
