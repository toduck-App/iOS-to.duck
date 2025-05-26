import UIKit

public enum TimerButtonState {
    case play
    case pause
    case stop
    case reset

    var primaryImage: UIImage {
        switch self {
        case .play:
            return TDImage.Timer.playPrimary.withRenderingMode(.alwaysTemplate)
        case .pause:
            return TDImage.Timer.pausePrimary.withRenderingMode(.alwaysTemplate)
        case .stop:
            return TDImage.Timer.stopPrimary.withRenderingMode(.alwaysTemplate)
        case .reset:
            return TDImage.Timer.resetPrimary.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var neutralImage: UIImage {
        switch self {
        case .play:
            return TDImage.Timer.playNeutral.withRenderingMode(.alwaysTemplate)
        case .pause:
            return TDImage.Timer.pauseNeutral.withRenderingMode(.alwaysTemplate)
        case .stop:
            return TDImage.Timer.stopNeutral.withRenderingMode(.alwaysTemplate)
        case .reset:
            return TDImage.Timer.resetNeutral.withRenderingMode(.alwaysTemplate)
        }
    }
}
