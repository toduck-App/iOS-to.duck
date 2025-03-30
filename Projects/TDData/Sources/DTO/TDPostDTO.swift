import Foundation
import TDDomain

public struct TDPostListDTO: Codable {
    let hasMore: Bool
    let nextCursor: Int?
    let results: [TDPostDTO]
}

public struct TDPostDTO: Codable {
    let socialId: Int
    let owner: TDOwnerDTO
    let routine: TDRoutineDTO?
    let title: String?
    let content: String?
    let hasImages: Bool
    let images: [TDSocialImageDTO]
    let socialLikeInfo: TDSocialLikeInfoDTO
    let comments: [TDSocialCommentDTO]?
    let commentCount: Int?
    let createdAt: String
    
    public struct TDOwnerDTO: Codable {
        let ownerId: Int
        let nickname: String
        let profileImageUrl: String?
        
        func convertToEntity() -> User {
            return User(
                id: ownerId,
                name: nickname,
                icon: profileImageUrl,
                // TODO: 뱃지 정보가 아직 미구현
                title: "작심삼일",
                // TODO: 차단 정보도 어떻게 되었는지 물어보기
                isblock: false
            )
        }
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
        comments: [TDSocialCommentDTO]?,
        commentCount: Int?,
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
        self.commentCount = commentCount
        self.createdAt = createdAt
    }
    
    func convertToEntity(category: [PostCategory]? = nil) -> Post {
        return Post(
            id: socialId,
            user: owner.convertToEntity(),
            contentText: content ?? "",
            imageList: images.map { $0.url },
            timestamp: Date.convertFromString(createdAt, format: .serverDate) ?? Date(),
            likeCount: socialLikeInfo.likeCount,
            isLike: socialLikeInfo.isLikedByMe,
            commentCount: commentCount,
            shareCount: nil,
            routine: routine?.convertToEntity(),
            category: category
        )
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
