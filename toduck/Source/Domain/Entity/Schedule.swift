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
    
    // MARK: - Date 타입으로부터 날짜와 시간을 받아오기
    
    func dateString() -> String? {
        guard let date = dateAndTime else { return nil }
        
        return Date.stringFromDate(date)
    }
    
    func timeString(use24HourFormat: Bool) -> String? {
        guard let time = dateAndTime else { return nil }
        
        return Date.stringFromTime(time, use24HourFormat: use24HourFormat)
    }
}
