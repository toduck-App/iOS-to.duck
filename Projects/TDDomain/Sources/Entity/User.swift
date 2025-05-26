import Foundation

public struct User: Identifiable {
    public let id: Int
    public let name: String
    public let icon: String?
    public let title: String
    
    public init(
        id: Int,
        name: String,
        icon: String?,
        title: String
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.title = title
    }
}



public extension User {
    static let dummy: [User] = [
        .init(id: 1, name: "오리발", icon: "https://avatars.githubusercontent.com/u/46300191?v=4", title: "작심삼일"),
        .init(id: 2, name: "꽉꽉", icon: "https://avatars.githubusercontent.com/u/129862357?v=4", title: "작심삼일"),
        .init(id: 3, name: "오리궁뎅이", icon: "https://avatars.githubusercontent.com/u/57449485?v=4", title: "작심삼일"),
        .init(id: 4, name: "꽉꽉", icon: nil, title: "작심삼일"),
        .init(id: 5, name: "오리궁뎅이", icon: nil, title: "작심삼일"),
    ]
}
