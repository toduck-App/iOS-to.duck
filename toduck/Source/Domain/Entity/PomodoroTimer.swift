//
//  Timer.swift
//  toduck
//
//  Created by 박효준 on 5/31/24.
//

import Foundation
import UIKit

struct Time {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    // TimeInterval을 통해 총 시간 계산
    var timeInterval: TimeInterval {
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds)
    }
    
    // MARK: 시간 문자열 반환
    func formattedString() -> String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

enum Theme {
    case blue
    case orange
}

enum TimeState {
    case running
    case stop
    case done
}

enum WhiteNoise {
    case rain
    case thunder
}

struct PomodoroTimer {
    var studyingToduckImage: UIImage
    var timerState: TimeState
    var theme: Theme
    var whiteNoise: WhiteNoise?
    var todayConcentrationTime: Time?
    var curConcentrationTime: Time?
}
