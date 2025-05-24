public struct NotificationResponseDTO: Codable {
    public let notifications: [NotificationResponseDTO]
}

public struct NotificationDetailResponseDTO: Codable {
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
