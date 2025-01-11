import Foundation

public protocol FetchUserPostUseCase {
    func execute(id: User.ID) async throws -> [Post]?
}

public final class FetchUserPostUseCaseImpl: FetchUserPostUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(id: User.ID) async throws -> [Post]? {
        return try await repostiory.fetchUserPostList(userID: id)
    }
}
