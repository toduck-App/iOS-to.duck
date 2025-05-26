import Foundation

public protocol UpdateCommentUseCase {
    func execute(comment: Comment) async throws -> Bool
}

public final class UpdateCommentUseCaseImpl: UpdateCommentUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(comment: Comment) async throws -> Bool {
        return try await repository.updateComment(comment: comment)
    }
}
