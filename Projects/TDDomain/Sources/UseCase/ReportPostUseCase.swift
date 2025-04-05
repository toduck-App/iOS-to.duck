import Foundation

public protocol ReportPostUseCase {
    func execute(postID: Post.ID) async throws
}

public final class ReportPostUseCaseImpl: ReportPostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws {
        return try await repository.reportPost(postID: postID)
    }
}
