public enum NotificationInfo {
    case comment(commenterName: String, commentContent: String, postId: Int)
    case reply(replierName: String, replyContent: String, postId: Int, commentId: Int)
    case replyOnMyPost(replierName: String, replyContent: String, postId: Int, commentId: Int)
    case like(likerName: String, postId: Int)
    case likeOnComment(likerName: String, postId: Int, commentId: Int)
    case follow(followerName: String)
    case routineShare(routineTitle: String, shareCount: Int)

    public var senderName: String {
        switch self {
        case .comment(let name, _, _): return name
        case .reply(let name, _, _, _): return name
        case .replyOnMyPost(let name, _, _, _): return name
        case .like(let name, _): return name
        case .likeOnComment(let name, _, _): return name
        case .follow(let name): return name
        case .routineShare: return ""
        }
    }

    public var titleText: String {
        switch self {
        case .comment(let name, _, _):
            return "\(name)님이 내 게시물에 댓글을 남겼어요."
        case .reply(let name, _, _, _):
            return "\(name)님이 대댓글을 남겼어요."
        case .replyOnMyPost(let name, _, _, _):
            return "\(name)님이 내 게시글에 대댓글을 남겼어요."
        case .like(let name, _):
            return "\(name)님이 내 게시글에 좋아요를 남겼어요."
        case .likeOnComment(let name, _, _):
            return "\(name)님이 내 댓글에 좋아요를 남겼어요."
        case .follow(let name):
            return "\(name)님이 나를 팔로우 합니다."
        case .routineShare:
            return "루틴 총 공유수가 100회를 돌파했어요! 🎉"
        }
    }

    public var subtitleText: String? {
        switch self {
        case .comment(_, let content, _):
            return content
        case .reply(_, let content, _, _):
            return content
        case .replyOnMyPost(_, let content, _, _):
            return content
        case .routineShare:
            return "나의 인기 루틴을 확인해보세요."
        default:
            return nil
        }
    }
}


public struct TDNotificationList {
    public let notifications: [TDNotificationDetail]
    
    public init(notifications: [TDNotificationDetail]) {
        self.notifications = notifications
    }
}
public struct TDNotificationDetail {
    public let id: Int
    public let senderId: Int?
    public let senderImageUrl: String?
    public let type: String
    public let title: String
    public let body: String
    public let actionUrl: String?
    public let data: NotificationInfo
    public let isRead: Bool
    public let createdAt: String
    public var isFollowed: Bool?

    public init(
        id: Int,
        senderId: Int?,
        senderImageUrl: String?,
        type: String,
        title: String,
        body: String,
        actionUrl: String?,
        data: NotificationInfo,
        isRead: Bool,
        createdAt: String,
        isFollowed: Bool? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.senderImageUrl = senderImageUrl
        self.type = type
        self.title = title
        self.body = body
        self.actionUrl = actionUrl
        self.data = data
        self.isRead = isRead
        self.createdAt = createdAt
        self.isFollowed = isFollowed
    }

    public func withIsFollowed(_ isFollowed: Bool) -> TDNotificationDetail {
        return TDNotificationDetail(
            id: id,
            senderId: senderId,
            senderImageUrl: senderImageUrl,
            type: type,
            title: title,
            body: body,
            actionUrl: actionUrl,
            data: data,
            isRead: isRead,
            createdAt: createdAt,
            isFollowed: isFollowed
        )
    }
}
