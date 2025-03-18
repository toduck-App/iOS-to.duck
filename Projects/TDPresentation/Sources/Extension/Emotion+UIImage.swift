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
}
