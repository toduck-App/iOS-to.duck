import Foundation

public protocol SocialRepository {
    func fetchPostList(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func togglePostLike(postID: Post.ID, currentLike: Bool) async throws

    // MARK: - Post CRUD

    func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws
    func updatePost(post: Post) async throws
    func deletePost(postID: Post.ID) async throws
    func fetchPost(postID: Post.ID) async throws -> Post
    func reportPost(postID: Post.ID) async throws
    func blockPost(postID: Post.ID) async throws
    
    func toggleCommentLike(commentID: Comment.ID) async throws -> Result<Comment, Error>
    func reportComment(commentID: Comment.ID) async throws -> Bool
    func blockComment(commentID: Comment.ID) async throws -> Bool
    
    func fetchCommentList(postID: Post.ID) async throws -> [Comment]?
    func fetchCommentList(commentID: Comment.ID) async throws -> [Comment]?
    func fetchUserCommentList(userID: User.ID) async throws -> [Comment]?
    func createComment(comment: NewComment) async throws -> Bool
    func updateComment(comment: Comment) async throws -> Bool
    func deleteComment(commentID: Comment.ID) async throws -> Bool
}
