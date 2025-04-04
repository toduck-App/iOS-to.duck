import Foundation

public protocol FetchCommentUseCase {
    func execute(userID: User.ID) async throws -> [Comment]?
}

public final class FetchCommentUseCaseImpl: FetchCommentUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(userID: User.ID) async throws -> [Comment]? {
        return try await repository.fetchUserCommentList(userID: userID)
    }
}
