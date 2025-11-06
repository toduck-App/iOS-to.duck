import Foundation
import Combine

/// 소셜 피드 및 게시글, 댓글과 관련된 모든 데이터 흐름을 담당하는 Repository 인터페이스입니다.
public protocol SocialRepository {

    // MARK: - 게시글 스트림
    /// 게시글 목록을 Combine 스트림 형태로 제공합니다.
    /// ViewModel은 이를 구독하여 UI를 자동으로 갱신할 수 있습니다.
    var postPublisher: AnyPublisher<[Post], Never> { get }

    // MARK: - 모드 관리
    /// 기본 피드 모드로 전환합니다.
    func setModeDefault()
    /// 검색 모드로 전환합니다.
    func setModeSearch(_ keyword: String)

    // MARK: - 게시글 목록 조회
    /// 기본 피드(홈 피드)를 불러옵니다.
    func fetchPostList(cursor: Int?, limit: Int, category: [PostCategory]?) async throws

    /// 검색 결과 게시글 목록을 불러옵니다.
    func searchPost(keyword: String,
                    cursor: Int?,
                    limit: Int,
                    category: [PostCategory]?) async throws

    // MARK: - 게시글 생성 / 수정 / 삭제
    /// 게시글 좋아요를 토글합니다. (Optimistic UI 반영 포함)
    func togglePostLike(postID: Post.ID, currentLike: Bool) async throws

    /// 새로운 게시글을 생성합니다.
    func createPost(post: Post,
                    image: [(fileName: String, imageData: Data)]?) async throws -> Int

    /// 기존 게시글을 업데이트합니다.
    func updatePost(prevPost: Post,
                    updatePost: Post,
                    image: [(fileName: String, imageData: Data)]?) async throws

    /// 게시글을 삭제합니다.
    func deletePost(postID: Post.ID) async throws

    /// 단일 게시글을 서버에서 새로 요청합니다. (댓글 포함)
    func fetchPost(postID: Post.ID) async throws -> (Post, [Comment])

    // MARK: - 댓글 관련
    /// 댓글의 좋아요 상태를 토글합니다.
    func toggleCommentLike(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws

    /// 댓글을 생성합니다. (이미지 포함 가능)
    func createComment(postID: Post.ID,
                       parentId: Comment.ID?,
                       content: String,
                       image: (fileName: String, imageData: Data)?) async throws -> Comment.ID

    /// 댓글을 삭제합니다.
    func deleteComment(postID: Post.ID, commentID: Comment.ID) async throws

    // MARK: - 신고
    /// 게시글을 신고합니다.
    func reportPost(postID: Post.ID,
                    reportType: ReportType,
                    reason: String?,
                    blockAuthor: Bool) async throws

    /// 댓글을 신고합니다.
    func reportComment(postID: Post.ID,
                       commentID: Comment.ID,
                       reportType: ReportType,
                       reason: String?,
                       blockAuthor: Bool) async throws

    // MARK: - 페이징 및 갱신
    /// 피드를 처음부터 새로 불러옵니다. (cursor reset)
    func refresh(limit: Int, category: [PostCategory]?) async throws

    /// 검색을 새로 시작합니다. (cursor reset)
    func startSearch(keyword: String, limit: Int, category: [PostCategory]?) async throws

    /// 다음 페이지를 불러옵니다. (모드에 따라 default / search 분기)
    func loadMore(limit: Int, category: [PostCategory]?) async throws

    // MARK: - 현재 상태
    /// 현재 메모리 내 게시글 목록을 반환합니다.
    func currentPosts() async -> [Post]
}
