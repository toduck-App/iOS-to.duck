import Foundation

public protocol PostRepository {
    func fetchPostList(category: PostCategory?) async throws -> [Post]
    func searchPost(keyword: String, category: PostCategory?) async throws -> [Post]?
    func togglePostLike(postID: Post.ID) async throws -> Result<Post, Error>
    func bringUserRoutine(routine: Routine) async throws -> Routine

    // MARK: - Post CRUD

    func createPost(post: Post) async throws -> Bool
    func updatePost(post: Post) async throws -> Bool
    func deletePost(postID: Post.ID) async throws -> Bool
    func fetchPost(postID: Post.ID) async throws -> Post
    func reportPost(postID: Post.ID) async throws -> Bool
    func blockPost(postID: Post.ID) async throws -> Bool
}
