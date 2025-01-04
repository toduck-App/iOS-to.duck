import Foundation

public protocol ReportPostUseCase {
    func execute(postID: Post.ID) async throws -> Bool
}

public final class ReportPostUseCaseImpl: ReportPostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws -> Bool {
        return try await repository.reportPost(postID: postID)
    }
}
