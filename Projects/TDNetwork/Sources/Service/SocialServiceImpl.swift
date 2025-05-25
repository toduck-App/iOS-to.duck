import TDData

public struct SocialServiceImpl: SocialService {
    private let provider: MFProvider<SocialAPI>
    
    public init(provider: MFProvider<SocialAPI> = MFProvider<SocialAPI>()) {
        self.provider = provider
    }
    
    public func requestPosts(
        cursor: Int?,
        limit: Int = 20,
        categoryIDs: [Int]?
    ) async throws -> TDPostListDTO {
        let target = SocialAPI.fetchPostList(curser: cursor, limit: limit, categoryIds: categoryIDs)
        let response = try await provider.requestDecodable(of: TDPostListDTO.self, target)
        return response.value
    }
    public func requestCreatePost(requestDTO: TDPostCreateRequestDTO) async throws -> TDPostCreateResponseDTO {
        let response = try await provider.requestDecodable(of: TDPostCreateResponseDTO.self, .createPost(post: requestDTO))
        return response.value
    }
    
    public func requestPost(postID: Int) async throws -> TDPostDTO {
        let response = try await provider.requestDecodable(of: TDPostDTO.self, .fetchPost(postId: String(postID)))
        return response.value
    }
    
    public func requestDeletePost(postID: Int) async throws {
        let target = SocialAPI.deletePost(postId: postID)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func requestUpdatePost(requestDTO: TDPostUpdateRequestDTO) async throws {
        let target = SocialAPI.updatePost(post: requestDTO)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func requestSearchPosts(
        cursor: Int?,
        limit: Int,
        keyword: String,
        categoryIDs: [Int]?
    ) async throws -> TDPostListDTO {
        let target = SocialAPI.searchPost(keyword: keyword, cursor: cursor, limit: limit, categoryIds: categoryIDs)
        let response = try await provider.requestDecodable(of: TDPostListDTO.self, target)
        return response.value
    }
    
    public func requestLikePost(postID: Int) async throws {
        let target = SocialAPI.likePost(postId: postID)
        try await provider.requestDecodable(of: TDPostLikeDTO.self, target)
    }
    
    public func requestUnlikePost(postID: Int) async throws {
        let target = SocialAPI.unlikePost(postId: postID)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func requestReportPost(postID: Int, reportType: String, reason: String?, blockAuthor: Bool) async throws {
        let target = SocialAPI.reportPost(postId: postID, reportType: reportType, reason: reason, blockAuthor: blockAuthor)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func requestReportComment(postID: Int, commentID: Int, reportType: String, reason: String?, blockAuthor: Bool) async throws {
        let target = SocialAPI.reportComment(postId: postID, commentId: commentID, reportType: reportType, reason: reason, blockAuthor: blockAuthor)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    
    public func requestCreateComment(socialId: Int, content: String, parentId: Int?, imageUrl: String?) async throws -> Int {
        let target = SocialAPI.createComment(socialId: socialId, parentCommentId: parentId, content: content, imageUrl: imageUrl)
        let response = try await provider.requestDecodable(of: TDCommentCreateResponseDTO.self, target)
        return response.value.commentId
    }
    
    public func requestLikeComment(postID: Int, commentID: Int) async throws {
        let target = SocialAPI.likeComment(postId: postID, commentId: commentID)
        try await provider.requestDecodable(of: TDCommentLikeResponseDTO.self, target)
    }
    
    public func requestUnlikeComment(postID: Int, commentID: Int) async throws {
        let target = SocialAPI.unlikeComment(postId: postID, commentId: commentID)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func requestRemoveComment(postID: Int, commentID: Int) async throws {
        let target = SocialAPI.deleteComment(postId: postID, commentId: commentID)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
}
