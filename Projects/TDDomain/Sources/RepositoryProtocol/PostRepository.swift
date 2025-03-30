import Foundation

public protocol PostRepository {
    func fetchPostList(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func searchPost(keyword: String, category: [PostCategory]?) async throws -> [Post]?
    func togglePostLike(postID: Post.ID, currentLike: Bool) async throws
    func bringUserRoutine(routine: Routine) async throws -> Routine

    // MARK: - Post CRUD

    func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws
    func updatePost(post: Post) async throws
    func deletePost(postID: Post.ID) async throws
    func fetchPost(postID: Post.ID) async throws -> Post
    func reportPost(postID: Post.ID) async throws
    func blockPost(postID: Post.ID) async throws 
}
