import Foundation

public protocol FetchUserPostUseCase {
    func execute(userID: User.ID, cursor: Int?, limit: Int) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
}

public final class FetchUserPostUseCaseImpl: FetchUserPostUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(userID: User.ID, cursor: Int?, limit: Int) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        return try await repostiory.fetchUserPostList(userID: userID, cursor: cursor, limit: limit)
    }
}
