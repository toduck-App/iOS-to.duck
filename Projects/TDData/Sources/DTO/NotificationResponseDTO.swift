import TDDomain
public struct NotificationResponseDTO: Decodable {
    public let notifications: [NotificationDetailResponseDTO]
    
    func convertToTDNotification() -> TDNotificationList {
        return TDNotificationList(
            notifications:
                notifications.map { notification in
                    TDNotificationDetail(
                        id: notification.id,
                        type: notification.type,
                        title: notification.title,
                        body: notification.body,
                        actionUrl: notification.actionUrl,
                        data: NotificationInfo(
                            commenterName: notification.data.commenterName,
                            commentContent: notification.data.commentContent,
                            postId: notification.data.postId
                        ),
                        isRead: notification.isRead,
                        createdAt: notification.createdAt
                    )
                }
        )
    }
}

public struct NotificationDetailResponseDTO: Decodable {
    public let id: Int
    public let type: String
    public let title: String
    public let body: String
    public let actionUrl: String?
    public let data: NotificationInfoDTO
    public let isRead: Bool
    public let createdAt: String
    
    public init(
        id: Int,
        type: String,
        title: String,
        body: String,
        actionUrl: String?,
        data: NotificationInfoDTO,
        isRead: Bool,
        createdAt: String
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.actionUrl = actionUrl
        self.data = data
        self.isRead = isRead
        self.createdAt = createdAt
    }
}

public struct NotificationInfoDTO: Decodable {
    public let commenterName: String
    public let commentContent: String
    public let postId: Int
    
    public init(commenterName: String, commentContent: String, postId: Int) {
        self.commenterName = commenterName
        self.commentContent = commentContent
        self.postId = postId
    }
}
