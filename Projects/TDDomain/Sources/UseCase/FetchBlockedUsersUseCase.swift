import Foundation

public protocol FetchBlockedUsersUseCase {
    func execute() async throws -> [User]
}

public final class FetchBlockedUsersUseCaseImpl: FetchBlockedUsersUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [User] {
        try await repository.fetchBlockList()
    }
}
