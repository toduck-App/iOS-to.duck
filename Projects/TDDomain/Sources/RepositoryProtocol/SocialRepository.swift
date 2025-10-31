import Foundation
import Combine

public protocol SocialRepository: AnyObject {
    // SSOT 발행
    var postPublisher: AnyPublisher<[Post], Never> { get }
    var postSubject: PassthroughSubject<[Post], Never> { get } // 레거시 호환

    // 모드 전환 (default / search)
    func setModeDefault()
    func setModeSearch(_ keyword: String)

    // 리스트 조회 (호출 시 SSOT 갱신 + 발행까지 수행)
    func currentPosts() async -> [Post]
    func refresh(limit: Int, category: [PostCategory]?) async throws
    func fetchPostList(cursor: Int?, limit: Int, category: [PostCategory]?) async throws
    func startSearch(keyword: String, limit: Int, category: [PostCategory]?) async throws
    func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws
    func loadMore(limit: Int, category: [PostCategory]?) async throws

    // 단건/상세 및 변경 API
    func togglePostLike(postID: Post.ID, currentLike: Bool) async throws
    func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws -> Int
    func updatePost(prevPost: Post, updatePost: Post, image: [(fileName: String, imageData: Data)]?) async throws
    func deletePost(postID: Post.ID) async throws

    func fetchPost(postID: Post.ID) async throws -> (Post, [Comment])

    func toggleCommentLike(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws
    func createComment(postID: Post.ID, parentId: Comment.ID?, content: String, image: (fileName: String, imageData: Data)?) async throws -> Comment.ID
    func updateComment(comment: Comment) async throws -> Bool
    func deleteComment(postID: Post.ID, commentID: Comment.ID) async throws
    func reportPost(postID: Post.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws
    func reportComment(postID: Post.ID, commentID: Comment.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws
}
