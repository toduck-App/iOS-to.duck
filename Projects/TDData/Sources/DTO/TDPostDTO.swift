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
    let comments: [TDComment]?
    let commentCount: Int?
    let categories: [TDSocialCategoryDTO]?
    let createdAt: String
    
    
    
    public init(
        socialId: Int,
        owner: TDOwnerDTO,
        routine: TDRoutineDTO?,
        title: String,
        content: String,
        hasImages: Bool,
        images: [TDSocialImageDTO],
        socialLikeInfo: TDSocialLikeInfoDTO,
        comments: [TDComment]?,
        commentCount: Int?,
        categories: [TDSocialCategoryDTO]?,
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
        self.categories = categories
        self.createdAt = createdAt
    }
    
    func convertToPost() -> Post {
        Post(
            id: socialId,
            user: owner.convertToEntity(),
            titleText: title,
            contentText: content ?? "",
            imageList: images.map(\.url),
            timestamp: Date.convertFromString(createdAt, format: .serverDate) ?? Date(),
            likeCount: socialLikeInfo.likeCount,
            isLike: socialLikeInfo.isLikedByMe,
            commentCount: commentCount ?? comments?.count,
            shareCount: nil,
            routine: routine?.convertToEntity(),
            category: categories?.map { PostCategory(rawValue: $0.socialCategoryId) ?? .normal } ?? []
        )
    }
    
    func convertToComment() -> [Comment] {
        guard let dtos = comments else { return [] }
        
        var topLevelComments: [Comment] = []
        var repliesDict: [Int: [Comment]] = [:]
        
        for dto in dtos {
            let commentDate = Date.convertFromString(dto.createdAt, format: .serverDate) ?? Date()
            let imageURL = dto.hasImage ? URL(string: dto.imageUrl ?? "") : nil
    
            let comment = Comment(
                id: dto.commentId,
                user: dto.owner.convertToEntity(),
                content: dto.content,
                imageURL: imageURL,
                timestamp: commentDate,
                isLike: dto.commentLikeInfo.isLikedByMe,
                likeCount: dto.commentLikeInfo.likeCount,
                comment: []
            )
            if let parentId = dto.parentCommentId {
                repliesDict[parentId, default: []].append(comment)
            } else {
                topLevelComments.append(comment)
            }
        }

        topLevelComments = topLevelComments.map { topComment in
            var modifiedComment = topComment
            if let replies = repliesDict[topComment.id] {
                modifiedComment.reply = replies
            }
            return modifiedComment
        }
        
        return topLevelComments
    }
}

public struct TDPostLikeDTO: Decodable {
    public let socialLikeId: Int
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

public struct TDPostUpdateRequestDTO: Encodable {
    public let id: Int
    public let isChangeTitle: Bool
    /// 변경할 제목.
    /// - `isChangeTitle == true` 이면
    ///   - `title != nil` : 해당 문자열로 제목 변경
    ///   - `title == nil` : 제목 삭제
    /// - `isChangeTitle == false` 이면
    ///   - `title` 은 무시 (`null` 이거나 미포함)
    public let title: String?

    /// 루틴 변경 여부 (필수)
    public let isChangeRoutine: Bool
    /// 변경할 루틴 ID.
    /// - 루틴 제거: `isChangeRoutine = true`, `routineId = nil`
    /// - 루틴 유지: `isChangeRoutine = false`, `routineId = nil`
    /// - 루틴 변경: `isChangeRoutine = true`, `routineId = 새 ID`
    public let routineId: Int?

    /// 본문 내용.
    /// - `nil` 이면 본문 유지
    /// - 문자열이 있으면 해당 문자열로 교체
    public let content: String?

    /// 익명 여부.
    /// - `nil` 이면 기존 값 유지
    /// - `true`/`false` 이면 변경
    public let isAnonymous: Bool?

    /// 카테고리 ID 리스트.
    /// - `nil` 이면 카테고리 유지
    /// - 빈 배열 → 예외
    /// - 1개 이상 배열 → 해당 ID로 변경
    public let socialCategoryIds: [Int]?

    /// 이미지 URL 리스트.
    /// - `nil` 이면 이미지 유지
    /// - 빈 배열 `[]` → 기존 이미지 모두 제거
    /// - 1개 이상 배열 → 해당 URL 리스트로 교체
    /// - 6개 이상 배열 → 예외
    public let socialImageUrls: [String]?
}

public struct TDCommentCreateResponseDTO: Decodable {
    public let commentId: Int
}

public struct TDCommentLikeResponseDTO: Decodable {
    public let commentLikeId: Int
}

public struct TDOwnerDTO: Codable {
    let ownerId: Int
    let nickname: String
    let profileImageUrl: String?
    
    func convertToEntity() -> User {
        User(
            id: ownerId,
            name: nickname,
            icon: profileImageUrl,
            // TODO: 뱃지 정보가 아직 미구현
            title: "작심삼일"
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

public struct TDSocialCategoryDTO: Codable {
    public let socialCategoryId: Int
    public let name: String
}

public struct TDBlockedUserListDTO: Codable {
    public let blockedUsers: [TDBlockedUser]
    
    public struct TDBlockedUser: Codable {
        public let userId: Int
        public let nickname: String
        public let profileImageUrl: String?
        
        func convertToEntity() -> User {
            User(
                id: userId,
                name: nickname,
                icon: profileImageUrl,
                title: "작심삼일"
            )
        }
    }
}
