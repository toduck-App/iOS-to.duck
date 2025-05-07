import Foundation

public protocol ReportPostUseCase {
    func execute(postID: Post.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws
}

public final class ReportPostUseCaseImpl: ReportPostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws {
        return try await repository.reportPost(postID: postID, reportType: reportType, reason: reason, blockAuthor: blockAuthor)
    }
}
