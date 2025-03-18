import UIKit
import TDDesign
import TDDomain

extension Emotion {
    init(diary: Diary) {
        self.init(fromRawValue: diary.emotion.rawValue)
    }
    
    init(fromRawValue rawValue: String) {
        switch rawValue {
        case "happy": self = .happy
        case "good": self = .good
        case "sad": self = .sad
        case "angry": self = .angry
        case "anxious": self = .anxious
        case "tired": self = .tired
        case "sick": self = .sick
        case "soso": self = .soso
        case "love": self = .love
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
