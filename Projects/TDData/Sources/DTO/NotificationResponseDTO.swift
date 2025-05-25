import TDDomain

public enum AnyNotificationData {
    case comment(NotificationCommentDTO)
    case reply(NotificationReplyDTO)
    case replyOnMyPost(NotificationReplyOnMyPostDTO)
    case like(NotificationLikeDTO)
    case likeOnComment(NotificationLikeOnCommentDTO)
    case follow(NotificationFollowDTO)
    case routineShare(NotificationRoutineShareDTO)
}

public struct NotificationResponseDTO: Decodable {
    public let notifications: [NotificationDetailResponseDTO]
    
    func convertToTDNotification() -> TDNotificationList {
        TDNotificationList(
            notifications: notifications.map { notification in
                let info: NotificationInfo

                switch notification.data {
                case .comment(let dto):
                    info = .comment(
                        commenterName: dto.commenterName,
                        commentContent: dto.commentContent,
                        postId: dto.postId
                    )
                case .reply(let dto):
                    info = .reply(
                        replierName: dto.replierName,
                        replyContent: dto.replyContent,
                        postId: dto.postId,
                        commentId: dto.commentId
                    )
                case .replyOnMyPost(let dto):
                    info = .replyOnMyPost(
                        replierName: dto.replierName,
                        replyContent: dto.replyContent,
                        postId: dto.postId,
                        commentId: dto.commentId
                    )
                case .like(let dto):
                    info = .like(
                        likerName: dto.likerName,
                        postId: dto.postId
                    )
                case .likeOnComment(let dto):
                    info = .likeOnComment(
                        likerName: dto.likerName,
                        postId: dto.postId,
                        commentId: dto.commentId
                    )
                case .follow(let dto):
                    info = .follow(
                        followerName: dto.followerName
                    )
                case .routineShare(let dto):
                    info = .routineShare(
                        routineTitle: dto.routineTitle,
                        shareCount: dto.shareCount
                    )
                }

                return TDNotificationDetail(
                    id: notification.id,
                    senderId: notification.senderId,
                    senderImageUrl: notification.senderImageUrl,
                    type: notification.type,
                    title: notification.title,
                    body: notification.body ?? "",
                    actionUrl: notification.actionUrl,
                    data: info,
                    isRead: notification.isRead,
                    createdAt: notification.createdAt
                )
            }
        )
    }
}

public struct NotificationDetailResponseDTO: Decodable {
    public let id: Int
    public let senderId: Int?
    public let senderImageUrl: String?
    public let type: String
    public let title: String
    public let body: String?
    public let actionUrl: String?
    public let data: AnyNotificationData
    public let isRead: Bool
    public let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, senderId, senderImageUrl, type, title, body, actionUrl, data, isRead, createdAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.senderId = try container.decodeIfPresent(Int.self, forKey: .senderId)
        self.senderImageUrl = try container.decodeIfPresent(String.self, forKey: .senderImageUrl)
        self.type = try container.decode(String.self, forKey: .type)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.actionUrl = try container.decodeIfPresent(String.self, forKey: .actionUrl)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)

        switch type {
        case "COMMENT":
            let dto = try container.decode(NotificationCommentDTO.self, forKey: .data)
            self.data = .comment(dto)
        case "REPLY":
            let dto = try container.decode(NotificationReplyDTO.self, forKey: .data)
            self.data = .reply(dto)
        case "REPLY_ON_MY_POST":
            let dto = try container.decode(NotificationReplyOnMyPostDTO.self, forKey: .data)
            self.data = .replyOnMyPost(dto)
        case "LIKE_POST":
            let dto = try container.decode(NotificationLikeDTO.self, forKey: .data)
            self.data = .like(dto)
        case "LIKE_COMMENT":
            let dto = try container.decode(NotificationLikeOnCommentDTO.self, forKey: .data)
            self.data = .likeOnComment(dto)
        case "FOLLOW":
            let dto = try container.decode(NotificationFollowDTO.self, forKey: .data)
            self.data = .follow(dto)
        case "ROUTINE_SHARE_MILESTONE":
            let dto = try container.decode(NotificationRoutineShareDTO.self, forKey: .data)
            self.data = .routineShare(dto)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown notification type: \(type)")
        }
    }
}

public struct NotificationCommentDTO: Decodable {
    public let commenterName: String
    public let commentContent: String
    public let postId: Int
    
    public init(commenterName: String, commentContent: String, postId: Int) {
        self.commenterName = commenterName
        self.commentContent = commentContent
        self.postId = postId
    }
}

public struct NotificationReplyDTO: Decodable {
    public let replierName: String
    public let replyContent: String
    public let postId: Int
    public let commentId: Int
    
    public init(
        replierName: String,
        replyContent: String,
        postId: Int,
        commentId: Int
    ) {
        self.replierName = replierName
        self.replyContent = replyContent
        self.postId = postId
        self.commentId = commentId
    }
}

public struct NotificationReplyOnMyPostDTO: Decodable {
    public let replierName: String
    public let replyContent: String
    public let postId: Int
    public let commentId: Int
    
    public init(
        replierName: String,
        replyContent: String,
        postId: Int,
        commentId: Int
    ) {
        self.replierName = replierName
        self.replyContent = replyContent
        self.postId = postId
        self.commentId = commentId
    }
}

public struct NotificationLikeDTO: Decodable {
    public let likerName: String
    public let postId: Int
    
    public init(likerName: String, postId: Int) {
        self.likerName = likerName
        self.postId = postId
    }
}

public struct NotificationLikeOnCommentDTO: Decodable {
    public let likerName: String
    public let postId: Int
    public let commentId: Int
    
    public init(likerName: String, postId: Int, commentId: Int) {
        self.likerName = likerName
        self.postId = postId
        self.commentId = commentId
    }
}

public struct NotificationFollowDTO: Decodable {
    public let followerName: String
    
    public init(followerName: String) {
        self.followerName = followerName
    }
}

public struct NotificationRoutineShareDTO: Decodable {
    public let routineTitle: String
    public let shareCount: Int
    
    public init(routineTitle: String, shareCount: Int) {
        self.routineTitle = routineTitle
        self.shareCount = shareCount
    }
}
