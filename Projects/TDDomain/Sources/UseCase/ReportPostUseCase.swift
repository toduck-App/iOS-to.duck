import Foundation

public protocol ReportPostUseCase {
    func execute(post: Post) async throws -> Bool
}

public final class ReportPostUseCaseImpl: ReportPostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(post: Post) async throws -> Bool {
        return try await repository.reportPost(postId: post.id)
    }
}
