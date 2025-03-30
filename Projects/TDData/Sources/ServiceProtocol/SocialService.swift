import TDDomain

public protocol SocialService {
    // 게시물 목록 조회(카테고리 필터 가능)
    func requestPosts(cursor: Int?, limit: Int, categoryIDs: [Int]?) async throws -> TDPostListDTO
    // 소셜 게시글 생성
    @discardableResult
    func requestCreatePost(requestDTO: TDPostCreateRequestDTO) async throws -> TDPostCreateResponseDTO
    // 게시글 단건 조회
    func requestPost(postID: Int) async throws -> TDPostDTO
    // 소셜 게시글 삭제
    func requestDeletePost(postID: Int) async throws
    // 소셜 게시글 수정
    func requestUpdatePost(postID: Int, isChangeTitle: Bool, title: String?, isChangeRoutine: Bool, routineID: Int?, content: String?, isAnonymous: Bool?, socialCategoryIds: [Int]?, socialImageURLs: [String]?) async throws
    // 게시글 검색
    func requestSearchPosts(cursor: Int, limit: Int, keyword: String) async throws
    // 게시글 좋아요
    func requestLikePost(postID: Int) async throws
    // 게시글 좋아요 취소
    func requestUnlikePost(postID: Int) async throws
}
