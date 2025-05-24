import TDDomain

public struct NotificationResponseDTO: Decodable {
    public let notifications: [NotificationDetailResponseDTO]

    func convertToTDNotification() -> TDNotificationList {
        TDNotificationList(
            notifications: notifications.map {
                TDNotificationDetail(
                    id: $0.id,
                    type: $0.type,
                    title: $0.title,
                    body: $0.body,
                    actionUrl: $0.actionUrl,
                    data: $0.data,
                    isRead: $0.isRead,
                    createdAt: $0.createdAt
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
    public let data: [String: String]
    public let isRead: Bool
    public let createdAt: String

    public init(
        id: Int,
        type: String,
        title: String,
        body: String,
        actionUrl: String?,
        data: [String: String],
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
