import Foundation

public protocol ReportPostUseCase {
    func execute(postID: Post.ID) async throws
}

public final class ReportPostUseCaseImpl: ReportPostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws {
        return try await repository.reportPost(postID: postID)
    }
}
