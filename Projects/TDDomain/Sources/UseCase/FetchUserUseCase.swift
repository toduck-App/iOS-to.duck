import Foundation

public protocol FetchUserUseCase {
    func execute(id: User.ID) async throws -> (User, UserDetail)
}

public final class FetchUserUseCaseImpl: FetchUserUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(id: User.ID) async throws -> (User, UserDetail) {
        return try await repostiory.fetchUser(userID: id)
    }
}
