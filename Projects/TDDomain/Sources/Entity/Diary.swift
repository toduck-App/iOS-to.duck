import Foundation

public struct Diary: Hashable, Identifiable {
    public let id: Int
    public let date: Date
    public let emotion: Emotion
    public let title: String
    public let contentText: String
    public let imagesURL: [String]?
    
    public init(
        id: Int,
        date: Date,
        emotion: Emotion,
        title: String,
        contentText: String,
        imagesURL: [String]?
    ) {
        self.id = id
        self.date = date
        self.emotion = emotion
        self.title = title
        self.contentText = contentText
        self.imagesURL = imagesURL
    }
}
