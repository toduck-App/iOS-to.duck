import Foundation

public protocol FetchUserUseCase {
    func execute(id: User.ID) async throws -> User
}

public final class FetchUserUseCaseImpl: FetchUserUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(id: User.ID) async throws -> User {
        return try await repostiory.fetchUser(userId: id)
    }
}
