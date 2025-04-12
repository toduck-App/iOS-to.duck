import Foundation

public protocol SocialRepository {
    func fetchPostList(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func togglePostLike(postID: Post.ID, currentLike: Bool) async throws

    // MARK: - Post CRUD

    func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws
    func updatePost(post: Post) async throws
    func deletePost(postID: Post.ID) async throws
    func fetchPost(postID: Post.ID) async throws -> (Post, [Comment])
    func reportPost(postID: Post.ID) async throws
    
    func toggleCommentLike(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws
    func reportComment(commentID: Comment.ID) async throws -> Bool
    
    func fetchUserCommentList(userID: User.ID) async throws -> [Comment]?
    func createComment( postID: Post.ID, parentId: Comment.ID?, content: String, image: (fileName: String, imageData: Data)?) async throws
    func updateComment(comment: Comment) async throws -> Bool
    func deleteComment(postID: Post.ID, commentID: Comment.ID) async throws
}
