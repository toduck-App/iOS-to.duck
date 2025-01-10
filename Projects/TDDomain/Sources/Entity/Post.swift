import Foundation

public struct Post: Identifiable {
    public let id: UUID
    public let user: User
    public let contentText: String
    public let imageList: [String]?
    public let timestamp: Date
    
    public var likeCount: Int?
    public var isLike: Bool
    public let commentCount: Int?
    public let shareCount: Int?
    public let routine: Routine?
    
    // 보이지 않는 property
    public let category: [PostCategory]?
    
    public init(
        id: UUID,
        user: User,
        contentText: String,
        imageList: [String]?,
        timestamp: Date,
        likeCount: Int?,
        isLike: Bool,
        commentCount: Int?,
        shareCount: Int?,
        routine: Routine?,
        category: [PostCategory]?
    ) {
        self.id = id
        self.user = user
        self.contentText = contentText
        self.imageList = imageList
        self.timestamp = timestamp
        self.likeCount = likeCount
        self.isLike = isLike
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.routine = routine
        self.category = category
    }
}

public extension Post {
    static let dummy: [Post] = [Post(id: UUID(),
                                     user: .init(id: UUID(), name: "오리발", icon: "https://avatars.githubusercontent.com/u/46300191?v=4", title: "작심삼일", isblock: false),
                                     contentText: "콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요? ",
                                     imageList: ["https://pbs.twimg.com/media/EFHWmyXUEAASe0o.jpg", "https://pbs.twimg.com/media/EHsTI9GUcAAOvS1.jpg:small"],
                                     timestamp: DateComponents(calendar: .current, year: 2024, month: 6, day: 13, hour: 13, minute: 30).date!,
                                     likeCount: 21,
                                     isLike: true,
                                     commentCount: 3,
                                     shareCount: nil,
                                     routine: nil,
                                     category: [.anxiety, .impulse]),
                                Post(
                                    id: UUID(),
                                    user: .init(id: UUID(), name: "꽉꽉", icon: "https://avatars.githubusercontent.com/u/129862357?v=4", title: "작심삼일", isblock: false),
                                    contentText: "어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️",
                                    imageList: ["https://pbs.twimg.com/media/EHsTI9GUcAAOvS1.jpg:small", "https://pbs.twimg.com/media/EHsTI9GUcAAOvS1.jpg:small",
                                                "https://pbs.twimg.com/media/EHsTI9GUcAAOvS1.jpg:small",
                                                "https://pbs.twimg.com/media/EHsTI9GUcAAOvS1.jpg:small",
                                                "https://pbs.twimg.com/media/EHsTI9GUcAAOvS1.jpg:small"],
                                    timestamp: DateComponents(calendar: .current, year: 2024, month: 10, day: 13, hour: 13, minute: 30).date!,
                                    likeCount: 46,
                                    isLike: false,
                                    commentCount: 3,
                                    shareCount: 12,
                                    routine: Routine(
                                        id: UUID(),
                                        title: "나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자",
                                        category: TDCategory(
                                            colorHex: "#123456",
                                            imageIndex: 0
                                        ),
                                        isAllDay: false,
                                        isPublic: false,
                                        date: nil,
                                        time: nil,
                                        repeatDays: [.friday, .saturday],
                                        alarmTimes: [.oneDayBefore],
                                        memo: "지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산",
                                        recommendedRoutines: nil,
                                        isFinish: false
                                    ),
                                    category: [.anxiety, .impulse]
                                ),
                                Post(id: UUID(),
                                     user: .init(id: UUID(), name: "오리궁뎅이", icon: "https://avatars.githubusercontent.com/u/57449485?v=4", title: "작심삼일", isblock: false),
                                     contentText: "오늘은 피곤해서 진짜 일찍 자고싶은데 ㅠㅠ 잠이 안와서 괴로워요ㅠㅠㅠㅠㅠ",
                                     imageList: nil,
                                     timestamp: .now,
                                     likeCount: 46,
                                     isLike: true,
                                     commentCount: 1,
                                     shareCount: 12,
                                     routine: nil,
                                     category: [.anxiety, .memory, .sleep]),
                                Post(
                                    id: UUID(),
                                    user: .init(id: UUID(), name: "꽉꽉", icon: nil, title: "작심삼일", isblock: false),
                                    contentText: "어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️",
                                    imageList: nil,
                                    timestamp: .now,
                                    likeCount: 46,
                                    isLike: false,
                                    commentCount: 7,
                                    shareCount: 12,
                                    routine: Routine(
                                        id: UUID(),
                                        title: "나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자",
                                        category: TDCategory(colorHex: "#123456", imageIndex: 0),
                                        isAllDay: false,
                                        isPublic: false,
                                        date: nil,
                                        time: nil,
                                        repeatDays: [.friday, .saturday],
                                        alarmTimes: [.oneDayBefore],
                                        memo: "지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산",
                                        recommendedRoutines: nil,
                                        isFinish: false
                                    ),
                                    category: [.anxiety, .impulse, .anxiety]
                                ),
                                Post(id: UUID(),
                                     user: .init(id: UUID(), name: "오리궁뎅이", icon: nil, title: "작심삼일", isblock: false),
                                     contentText: "오늘은 피곤해서 진짜 일찍 자고싶은데 ㅠㅠ 잠이 안와서 괴로워요ㅠㅠㅠㅠㅠ",
                                     imageList: nil,
                                     timestamp: .now,
                                     likeCount: 46,
                                     isLike: true,
                                     commentCount: 7,
                                     shareCount: 12,
                                     routine: nil,
                                     category: [.anxiety, .concentration, .memory])]
}

extension Post: Equatable {
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Post: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
