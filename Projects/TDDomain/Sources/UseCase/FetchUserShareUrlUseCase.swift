import Foundation

public protocol FetchUserShareUrlUseCase {
    func execute(userID: User.ID) async throws -> String
}

public final class FetchUserShareUrlUseCaseImpl: FetchUserShareUrlUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userID: User.ID) async throws -> String {
        return try await repository.fetchUserShareUrl(userID: userID)
    }
}
