public protocol RegisterDeviceTokenUseCase {
    func execute(token: String) async throws
}

public final class RegisterDeviceTokenUseCaseImpl: RegisterDeviceTokenUseCase {
    private let repository: NotificationRepository
    
    public init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    public func execute(token: String) async throws {
        try await repository.registerDeviceToken(token: token)
    }
}
