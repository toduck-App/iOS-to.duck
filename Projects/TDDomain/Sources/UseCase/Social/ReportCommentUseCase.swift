import Foundation

public protocol ReportCommentUseCase {
    func execute(postID: Post.ID, commentID: Comment.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws
}

public final class ReportCommentUseCaseImpl: ReportCommentUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID, commentID: Comment.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws {
        return try await repository.reportComment(
            postID: postID,
            commentID: commentID,
            reportType: reportType,
            reason: reason,
            blockAuthor: blockAuthor
        )
    }
}
