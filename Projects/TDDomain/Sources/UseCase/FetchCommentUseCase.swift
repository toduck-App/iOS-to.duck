import Foundation

public protocol FetchCommentUseCase {
    func execute(cursor: Int?, limit: Int) async throws -> (result: [Comment], hasMore: Bool, nextCursor: Int?)
}

public final class FetchCommentUseCaseImpl: FetchCommentUseCase {
    private let repository: UserRepository
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    public func execute(cursor: Int?, limit: Int) async throws -> (result: [Comment], hasMore: Bool, nextCursor: Int?) {
        try await repository.fetchMyCommentList(cursor: cursor, limit: limit)
    }
}
