import TDDomain

public struct DiaryPostRequestDTO: Encodable {
    public let date, emotion, title, memo: String
    public let diaryImageUrls: [String]
    
    public init(diary: Diary) {
        self.date = diary.date.convertToString(formatType: .yearMonthDay)
        self.emotion = diary.emotion.rawValue
        self.title = diary.title
        self.memo = diary.memo
        self.diaryImageUrls = diary.diaryImageUrls ?? [""]
    }
}
