//
//  Schedule.swift
//  toduck
//
//  Created by 박효준 on 5/31/24.
//

import Foundation

enum CategoryImage: String, Hashable {
    case a
}

enum Weekday: String, Hashable {
    case monday = "월", tuesday = "화", wednesday = "수",
         thursday = "목", friday = "금", saturday = "토", sunday = "일"
}

enum AlarmTime: String, Codable, Hashable {
    case oneHourBefore = "60"
    case thirtyMinutesBefore = "30"
    case tenMinutesBefore = "10"
}

public struct Schedule: Hashable {
    let id: Int
    var title: String
    var categoryImage: CategoryImage?
    var dateAndTime: Date?
    var isRepeating: Bool
    var repeatDays: [Weekday]?
    var alarm: Bool
    var alarmTimes: [AlarmTime]?
    var place: String?
    var memo: String?
    var isFinish: Bool
}
