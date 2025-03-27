import TDData

public struct SocialServiceImpl: SocialService {
    private let provider: MFProvider<SocialAPI>
    
    public init(provider: MFProvider<SocialAPI> = MFProvider<SocialAPI>()) {
        self.provider = provider
    }
    
    public func requestPosts(
        cursor: Int,
        limit: Int,
        categoryIDs: Int
    ) async throws -> TDPostDTO {
        let response = try await provider.requestDecodable(of: TDPostDTO.self, .fetchPostList(category: .anxiety))
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
        return
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
}
