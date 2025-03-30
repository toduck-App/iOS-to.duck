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
    
    public func requestUpdatePost(
        postID: Int,
        isChangeTitle: Bool,
        title: String?,
        isChangeRoutine: Bool,
        routineID: Int?,
        content: String?,
        isAnonymous: Bool?,
        socialCategoryIds: [Int]?,
        socialImageURLs: [String]?
    ) async throws {
        return
    }
    
    public func requestSearchPosts(
        cursor: Int,
        limit: Int,
        keyword: String
    ) async throws {
        return
    }
    
    public func requestLikePost(postID: Int) async throws {
        let target = SocialAPI.likePost(postId: postID)
        try await provider.requestDecodable(of: TDPostLikeDTO.self, target)
    }
    
    public func requestUnlikePost(postID: Int) async throws {
        let target = SocialAPI.unlikePost(postId: postID)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
}
