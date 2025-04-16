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
    func requestSearchPosts(cursor: Int?, limit: Int, keyword: String, categoryIDs: [Int]?) async throws -> TDPostListDTO
    // 게시글 좋아요
    func requestLikePost(postID: Int) async throws
    // 게시글 좋아요 취소
    func requestUnlikePost(postID: Int) async throws
    // 게시글 신고
    func requestReportPost(postID: Int, reportType: String, reason: String?, blockAuthor: Bool) async throws
    
    // 댓글 생성
    func requestCreateComment(socialId: Int, content: String, parentId: Int?, imageUrl: String?) async throws
    
    // 댓글 좋아요
    func requestLikeComment(postID: Int, commentID: Int) async throws
    
    // 댓글 좋아요 취소
    func requestUnlikeComment(postID: Int, commentID: Int) async throws
    
    func requestRemoveComment(postID: Int, commentID: Int) async throws
}
