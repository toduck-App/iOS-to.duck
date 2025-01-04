import Foundation
import UIKit

public struct Diary: Hashable, Identifiable {
    public let id: UUID
    public let focus: Focus
    public let emotion: Emotion
    public let contentText: String
    public let date: Date
    
    public init(
        id: UUID,
        focus: Focus,
        emotion: Emotion,
        contentText: String,
        date: Date
    ) {
        self.id = id
        self.focus = focus
        self.emotion = emotion
        self.contentText = contentText
        self.date = date
    }
    
    public var emotionImageName: String {
        return emotion.imageName
    }
}
