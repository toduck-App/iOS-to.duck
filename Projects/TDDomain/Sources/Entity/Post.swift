import Foundation

public struct Post: Identifiable {
    public let id: Int
    public let user: User
    public let titleText: String?
    public let contentText: String
    public let imageList: [String]?
    public let timestamp: Date
    
    public var likeCount: Int
    public var isLike: Bool
    public let commentCount: Int?
    public let shareCount: Int?
    public let routine: Routine?
    
    // 보이지 않는 property
    public let category: [PostCategory]?
    
    public init(
        id: Int,
        user: User,
        titleText: String? = nil,
        contentText: String,
        imageList: [String]?,
        timestamp: Date,
        likeCount: Int,
        isLike: Bool,
        commentCount: Int?,
        shareCount: Int?,
        routine: Routine?,
        category: [PostCategory]?
    ) {
        self.id = id
        self.user = user
        self.titleText = titleText
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
    
    public init(title: String?, content: String, routine: Routine?, category: [PostCategory]) {
        self.id = 0
        self.titleText = title
        self.contentText = content
        self.routine = routine
        self.category = category
        self.isLike = false
        self.likeCount = 0
        self.commentCount = 0
        self.shareCount = 0
        self.timestamp = Date()
        // 임시
        self.user = User(id: 1, name: "", icon: nil, title: "임시 사용자", isblock: false)
        self.imageList = nil
    }
    
    public mutating func toggleLike(){
        if isLike && likeCount > 0 {
            likeCount -= 1
        } else {
            likeCount += 1
        }
        isLike.toggle()
    }
}

public extension Post {
    static let dummy: [Post] = [Post(id: 1,
                                     user: User.dummy[0],
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
                                    id: 2,
                                    user: User.dummy[1],
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
                                        id: nil,
                                        title: "나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자",
                                        category: TDCategory(
                                            colorHex: "#123456",
                                            imageName: "computer"
                                        ),
                                        isAllDay: false,
                                        isPublic: false,
                                        time: nil,
                                        repeatDays: [.friday, .saturday],
                                        alarmTime: .tenMinutesBefore,
                                        memo: "지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산",
                                        recommendedRoutines: nil,
                                        isFinished: false
                                    ),
                                    category: [.anxiety, .impulse]
                                ),
                                Post(id: 3,
                                     user: User.dummy[2],
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
                                    id: 4,
                                    user: User.dummy[3],
                                    contentText: "어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️",
                                    imageList: nil,
                                    timestamp: .now,
                                    likeCount: 46,
                                    isLike: false,
                                    commentCount: 7,
                                    shareCount: 12,
                                    routine: Routine(
                                        id: nil,
                                        title: "나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자",
                                        category: TDCategory(colorHex: "#123456", imageName: "computer"),
                                        isAllDay: false,
                                        isPublic: false,
                                        time: nil,
                                        repeatDays: [.friday, .saturday],
                                        alarmTime: .tenMinutesBefore,
                                        memo: "지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산",
                                        recommendedRoutines: nil,
                                        isFinished: false
                                    ),
                                    category: [.anxiety, .impulse, .anxiety]
                                ),
                                Post(id: 5,
                                     user: User.dummy[4],
                                     contentText: "오늘은 피곤해서 진짜 일찍 자고싶은데 ㅠㅠ 잠이 안와서 괴로워요ㅠㅠㅠㅠㅠ",
                                     imageList: nil,
                                     timestamp: .now,
                                     likeCount: 46,
                                     isLike: true,
                                     commentCount: 7,
                                     shareCount: 12,
                                     routine: nil,
                                     category: [.anxiety, .concentration, .memory]),
                                Post(
                                    id: 6,
                                    user: User.dummy[4],
                                    titleText: "수면 관련 질문..",
                                    contentText: "최근들어 부쩍 수면의 질이 낮아져 너무 힘든데 도움되는 방법이 있을까요?",
                                    imageList: nil,
                                    timestamp: .now.addingTimeInterval(-1000),
                                    likeCount: 555,
                                    isLike: false,
                                    commentCount: 2,
                                    shareCount: nil,
                                    routine: nil,
                                    category: [.sleep])
                                ]
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
