import Foundation

public protocol FetchUserShareUrlUseCase {
    func execute(user: User) async throws -> String
}

public final class FetchUserShareUrlUseCaseImpl: FetchUserShareUrlUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(user: User) async throws -> String {
        return try await repository.fetchUserShareUrl(userId: user.id)
    }
}
