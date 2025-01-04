import UIKit

public enum TimerButtonState {
    case play
    case pause
    case stop
    case reset

    var icon: UIImage {
        switch self {
        case .play:
            return TDImage.Timer.play.withRenderingMode(.alwaysTemplate)
        case .pause:
            return TDImage.Timer.pause.withRenderingMode(.alwaysTemplate)
        case .stop:
            return TDImage.Timer.stop.withRenderingMode(.alwaysTemplate)
        case .reset:
            return TDImage.Timer.reset.withRenderingMode(.alwaysTemplate)
        }
    }

    var backgroundColor: UIColor {
        return UIColor(white: 1, alpha: 0.3)
    }

    var foregroundColor: UIColor {
        return .white
    }

    var outlineColor: UIColor {
        return UIColor(white: 1, alpha: 0.5)
    }
}
