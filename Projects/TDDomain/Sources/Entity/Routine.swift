//
//  Routine.swift
//  toduck
//
//  Created by 박효준 on 5/31/24.
//

import Foundation

struct RecommendedRoutine: Hashable {
    let title: String
    let time: Date? // AM 07:30
    let memo: String?
}

public struct Routine: Hashable {
    let id: Int
    var title: String
    var category: String? // 일정의 이모티콘 아님
    var isPublic: Bool
    var dateAndTime: Date?
    var isRepeating: Bool
    var isRepeatAllDay: Bool // 반복이 종일인지
    var repeatDays: [Weekday]?
    var alarm: Bool
    var alarmTimes: [AlarmTime]?
    var memo: String?
    var recommendedRoutines: [String]?
    var isFinish: Bool
}
