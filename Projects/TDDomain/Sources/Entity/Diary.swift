import Foundation

public struct Diary: Hashable, Identifiable {
    public let id: Int
    public let date: Date
    public let emotion: Emotion
    public let title: String
    public let memo: String
    public let diaryImageUrls: [String]?
    
    public init(
        id: Int,
        date: Date,
        emotion: Emotion,
        title: String,
        memo: String,
        diaryImageUrls: [String]?
    ) {
        self.id = id
        self.date = date
        self.emotion = emotion
        self.title = title
        self.memo = memo
        self.diaryImageUrls = diaryImageUrls
    }
}
