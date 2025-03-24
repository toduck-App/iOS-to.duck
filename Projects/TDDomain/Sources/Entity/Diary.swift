import Foundation

public struct Diary: Hashable, Identifiable {
    public let id: Int
    public let date: Date
    public let emotion: Emotion
    public let title: String
    public let sentenceText: String
    public let imagesURL: [String]?
    
    public init(
        id: Int,
        date: Date,
        emotion: Emotion,
        title: String,
        sentenceText: String,
        imagesURL: [String]?
    ) {
        self.id = id
        self.date = date
        self.emotion = emotion
        self.title = title
        self.sentenceText = sentenceText
        self.imagesURL = imagesURL
    }
}
