import Foundation
import TDDomain
import TDCore

public final class CommentRepositoryImpl: CommentRepository {
    private var comments: [Comment] = Comment.dummy
    public init() {}
    
    public func toggleCommentLike(commentID: Comment.ID) async throws -> Result<Comment, Error> {
        for index in comments.indices {
            // 댓글인 경우
            if comments[index].id == commentID {
                comments[index].toggleLike()
                return .success(comments[index])
            }
            // 대댓글인 경우
            if let replyIndex = comments[index].reply.firstIndex(where: { $0.id == commentID }) {
                comments[index].reply[replyIndex].toggleLike()
                return .success(comments[index])
            }
        }
        // TODO: 해당 ID를 가진 댓글이나 대댓글이 없는 경우
        return .failure(NSError(domain: "CommentRepositoryImpl", code: 0, userInfo: nil))
    }
    
    public func fetchCommentList(postID: Post.ID) async throws -> [Comment]? {
        comments
    }
    
    public func fetchCommentList(commentID: Comment.ID) async throws -> [Comment]? {
        []
    }
    
    public func fetchUserCommentList(userID: User.ID) async throws -> [Comment]? {
        []
    }
    
    public func createComment(comment newComment: NewComment) async throws -> Bool {
        let createdComment = Comment(
            id: UUID(),
            user: User(
                id: UUID(),
                name: "닉네임",
                icon: "",
                title: "작심삼일",
                isblock: false
            ),
            content: newComment.content,
            imageURL: URL(string: "https://picsum.photos/250/250"),
            timestamp: Date(),
            isLike: false,
            likeCount: 0,
            comment: []
        )
        
        switch newComment.target {
        case .post(let postID):
            // TODO: Network 작업을 통해 서버에 댓글을 등록하고, 성공 시 comments에 추가
            comments.append(createdComment)
            return true
            
        case .comment(let parentCommentID):
            // TODO: Network 작업을 통해 서버에 대댓글을 등록하고, 성공 시 comments에 추가
            // 현재는 부모 댓글을 찾아 대댓글을 추가
            var added = addReply(newComment: createdComment, toCommentID: parentCommentID, in: &comments)
            if added {
                return true
            } else {
                throw NSError(domain: "CommentRepositoryImpl", code: 404, userInfo: [NSLocalizedDescriptionKey: "부모 댓글을 찾을 수 없습니다."])
            }
        }
    }
    
    public func updateComment(comment: Comment) async throws -> Bool {
        false
    }
    
    public func deleteComment(commentID: Comment.ID) async throws -> Bool {
        false
    }
    
    public func reportComment(commentID: Comment.ID) async throws -> Bool {
        false
    }
    
    public func blockComment(commentID: Comment.ID) async throws -> Bool {
        false
    }
    
    // MARK: - Private Helper
    
    @discardableResult
    private func addReply(newComment: Comment, toCommentID parentCommentID: UUID, in commentsArray: inout [Comment]) -> Bool {
        for index in commentsArray.indices {
            if commentsArray[index].id == parentCommentID {
                commentsArray[index].reply.append(newComment)
                return true
            } else {
                if addReply(newComment: newComment, toCommentID: parentCommentID, in: &commentsArray[index].reply) {
                    return true
                }
            }
        }
        return false
    }
}
