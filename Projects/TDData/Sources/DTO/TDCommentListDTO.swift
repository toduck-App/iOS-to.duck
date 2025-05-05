import Foundation
import TDDomain

public struct TDCommentListDTO: Codable {
    let hasMore: Bool
    let nextCursor: Int?
    let results: [TDCommentResults]?

    func convertToComment() -> [Comment] {
        guard let dtos = results else { return [] }

        var topLevelComments: [Comment] = []
        var repliesDict: [Int: [Comment]] = [:]

        for dto in dtos {
            let commentDate = Date.convertFromString(dto.comment.createdAt, format: .serverDate) ?? Date()
            let imageURL = dto.comment.hasImage ? URL(string: dto.comment.imageUrl ?? "") : nil

            let comment = Comment(
                id: dto.comment.commentId,
                user: dto.comment.owner.convertToEntity(),
                content: dto.comment.content,
                imageURL: imageURL,
                timestamp: commentDate,
                isLike: dto.comment.commentLikeInfo.isLikedByMe,
                likeCount: dto.comment.commentLikeInfo.likeCount,
                comment: []
            )
            if let parentId = dto.comment.parentCommentId {
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

public struct TDCommentResults: Codable {
    let socialId: Int
    let comment: TDComment
}

public struct TDComment: Codable {
    let commentId: Int
    let parentCommentId: Int?
    let owner: TDOwnerDTO
    let imageUrl: String?
    let hasImage: Bool
    let content: String
    let commentLikeInfo: TDSocialLikeInfoDTO
    let isReply: Bool
    let createdAt: String
}
