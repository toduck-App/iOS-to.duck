import UIKit
import TDDesign
import TDDomain

extension Emotion {
    init(diary: Diary) {
        self.init(fromRawValue: diary.emotion.rawValue)
    }
    
    init(fromRawValue rawValue: String) {
        switch rawValue {
        case "HAPPY": self = .happy
        case "GOOD": self = .good
        case "SAD": self = .sad
        case "ANGRY": self = .angry
        case "ANXIOUS": self = .anxious
        case "TIRED": self = .tired
        case "SICK": self = .sick
        case "SOSO": self = .soso
        case "LOVE": self = .love
        default: self = .soso
        }
    }
    
    var image: UIImage {
        switch self {
        case .happy: TDImage.Mood.happy
        case .good: TDImage.Mood.good
        case .sad: TDImage.Mood.sad
        case .angry: TDImage.Mood.angry
        case .anxious: TDImage.Mood.anxious
        case .tired: TDImage.Mood.tired
        case .sick: TDImage.Mood.sick
        case .soso: TDImage.Mood.soso
        case .love: TDImage.Mood.love
        }
    }
    
    var largeImage: UIImage {
        switch self {
        case .happy: TDImage.Mood.Large.happy
        case .good: TDImage.Mood.Large.good
        case .sad: TDImage.Mood.Large.sad
        case .angry: TDImage.Mood.Large.angry
        case .anxious: TDImage.Mood.Large.anxious
        case .tired: TDImage.Mood.Large.tired
        case .sick: TDImage.Mood.Large.sick
        case .soso: TDImage.Mood.Large.soso
        case .love: TDImage.Mood.Large.love
        }
    }
    
    var circleImage: UIImage {
        switch self {
        case .happy: TDImage.MoodCircle.happy
        case .good: TDImage.MoodCircle.good
        case .sad: TDImage.MoodCircle.sad
        case .angry: TDImage.MoodCircle.angry
        case .anxious: TDImage.MoodCircle.anxious
        case .tired: TDImage.MoodCircle.tired
        case .sick: TDImage.MoodCircle.sick
        case .soso: TDImage.MoodCircle.soso
        case .love: TDImage.MoodCircle.love
        }
    }
}
