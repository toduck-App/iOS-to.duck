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
        createdAt: String
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
    }
}

public struct NotificationInfo {
    public let commenterName: String
    public let commentContent: String
    public let postId: Int
    
    public init(commenterName: String, commentContent: String, postId: Int) {
        self.commenterName = commenterName
        self.commentContent = commentContent
        self.postId = postId
    }
}
