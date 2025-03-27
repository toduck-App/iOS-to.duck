import Foundation

public struct TDPostDTO: Codable {
    let socialId: Int
    let owner: TDOwnerDTO
    let routine: TDRoutineDTO?
    let title: String
    let content: String
    let hasImages: Bool
    let images: [TDSocialImageDTO]
    let socialLikeInfo: TDSocialLikeInfoDTO
    let comments: [TDSocialCommentDTO]
    let createdAt: String
    
    public struct TDOwnerDTO: Codable {
        let ownerID: Int
        let nickname: String
    }
    
    public struct TDSocialImageDTO: Codable {
        let socialImageId: Int
        let url: String
    }
    
    public struct TDSocialLikeInfoDTO: Codable {
        let likeCount: Int
        let isLikedByMe: Bool
    }
    
    public struct TDSocialCommentDTO: Codable {
        let commentId: Int
        let parentCommentId: Int
        let owner: TDOwnerDTO
        let content: String
        let commentLikeInfo: TDSocialLikeInfoDTO
        let isReply: Bool
        let createdAt: String
    }
    
    public init(
        socialId: Int,
        owner: TDOwnerDTO,
        routine: TDRoutineDTO?,
        title: String,
        content: String,
        hasImages: Bool,
        images: [TDSocialImageDTO],
        socialLikeInfo: TDSocialLikeInfoDTO,
        comments: [TDSocialCommentDTO],
        createdAt: String
    ) {
        self.socialId = socialId
        self.owner = owner
        self.routine = routine
        self.title = title
        self.content = content
        self.hasImages = hasImages
        self.images = images
        self.socialLikeInfo = socialLikeInfo
        self.comments = comments
        self.createdAt = createdAt
    }
}


public struct TDPostCreateResponseDTO: Decodable {
    public let socialId: Int
}

public struct TDPostCreateRequestDTO: Encodable {
    public let title: String?
    public let content: String
    public let routineId: Int?
    public let isAnonymous: Bool
    public let socialCategoryIds: [Int]
    public let socialImageUrls: [String]?
}
