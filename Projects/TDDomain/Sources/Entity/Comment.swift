import Foundation

public struct Comment: Identifiable {
    public let id: UUID
    public let user: User
    public let content: String
    public let timestamp: Date
    public let isLike: Bool
    public let like: Int?
    public var reply: [Comment] = []

    public init(
        id: UUID,
        user: User,
        content: String,
        timestamp: Date,
        isLike: Bool,
        like: Int?,
        comment: [Comment]?
    ) {
        self.id = id
        self.user = user
        self.content = content
        self.timestamp = timestamp
        self.isLike = isLike
        self.like = like
        self.reply = comment ?? []
    }
}

public extension Comment {
    static let dummy: [Comment] = [
        Comment(
            id: UUID(),
            user: .init(
                id: UUID(),
                name: "꽉꽉",
                icon: "https://avatars.githubusercontent.com/u/129862357?v=4",
                title: "작심삼일",
                isblock: false
            ),
            content: """
            평소에 카페인이 들어있는 음식을 줄이시는 것도 좋을 것 같아요
            """,
            timestamp: Date(),
            isLike: true,
            like: 1,
            comment: [Comment(
                id: UUID(),
                user: .init(
                    id: UUID(),
                    name: "오리발",
                    icon: "https://avatars.githubusercontent.com/u/129862357?v=4",
                    title: "작심삼일",
                    isblock: false
                ),
                content: """
                커피를 끊기가 힘들어서 ㅜㅜ 그래도 오늘부터 노력해봐야겠어요!
                """,
                timestamp: Date(),
                isLike: true,
                like: 1,
                comment: []
            ),
            Comment(
                id: UUID(),
                user: .init(
                    id: UUID(),
                    name: "오리발",
                    icon: "https://avatars.githubusercontent.com/u/129862357?v=4",
                    title: "작심삼일",
                    isblock: false
                ),
                content: """
                커피를 끊기가 힘들어서 ㅜㅜ 그래도 오늘부터 노력해봐야겠어요!
                """,
                timestamp: Date(),
                isLike: true,
                like: 1,
                comment: []
            )]
        ),
        Comment(
            id: UUID(),
            user: .init(
                id: UUID(),
                name: "오리발",
                icon: "https://avatars.githubusercontent.com/u/46300191?v=4",
                title: "작심삼일",
                isblock: false
            ),
            content: """
            안녕하세요! 제가 비슷한 문제를 겪을 때 사용하는 방법이 있어서
            소개해드릴게요! 혹시 ‘4-7-8 호흡법'이라고 들어보셨나요?
            4-7-8 호흡법은 호흡을 조절해 긴장을 풀고 몸과 마음을 편안하게
            해주는 호흡법인데요, 저는 이 방법이 꽤나 효과적이더라구요!

            방법은 간단해요.
            1. 편안한 자세로 앉거나 눕는다.
            2. 입을 열고 숫자를 세며 4초 천천히 숨을 들이마신다.
            3. 들이마신 숨을 7초간 가슴과 복부에 고정시킨다.
            4. 8초 동안 입을 열고 숨을 내쉰다.
            5. 이 과정을 4번 반복한다.

             이 방법이 도움이 되었으면 좋겠네요. 좋은 하루 되세요!
            """,
            timestamp: Date(),
            isLike: false,
            like: 0,
            comment: []
        ),
    ]
}

extension Comment: Hashable {
    public static func == (
        lhs: Comment,
        rhs: Comment
    ) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(id)
    }
}
