import Foundation

public struct User: Identifiable {
    public let id: UUID
    public let name: String
    public let icon: String?
    public let title: String
    public let isblock: Bool
    
    public init(
        id: UUID,
        name: String,
        icon: String?,
        title: String,
        isblock: Bool
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.title = title
        self.isblock = isblock
    }
}



public extension User {
    static let dummy: [User] = [
        .init(id: UUID(), name: "오리발", icon: "https://avatars.githubusercontent.com/u/46300191?v=4", title: "작심삼일", isblock: false),
        .init(id: UUID(), name: "꽉꽉", icon: "https://avatars.githubusercontent.com/u/129862357?v=4", title: "작심삼일", isblock: false),
        .init(id: UUID(), name: "오리궁뎅이", icon: "https://avatars.githubusercontent.com/u/57449485?v=4", title: "작심삼일", isblock: false),
        .init(id: UUID(), name: "꽉꽉", icon: nil, title: "작심삼일", isblock: false),
        .init(id: UUID(), name: "오리궁뎅이", icon: nil, title: "작심삼일", isblock: false),
    ]
}
