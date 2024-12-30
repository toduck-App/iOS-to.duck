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

public struct Routine: Eventable {
    public let id: UUID
    public let title: String
    public let category: TDCategory
    public let isAllDay: Bool
    public let isPublic: Bool
    public let date: Date?
    public let time: Date?
    public let repeatDays: [TDWeekDay]?
    public let alarmTimes: [AlarmType]?
    public let memo: String?
    public let recommendedRoutines: [String]?
    public let isFinish: Bool
    
    public init(
        id: UUID,
        title: String,
        category: TDCategory,
        isAllDay: Bool,
        isPublic: Bool,
        date: Date?,
        time: Date?,
        repeatDays: [TDWeekDay]?,
        alarmTimes: [AlarmType]?,
        memo: String?,
        recommendedRoutines: [String]?,
        isFinish: Bool
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.isAllDay = isAllDay
        self.isPublic = isPublic
        self.date = date
        self.time = time
        self.repeatDays = repeatDays
        self.alarmTimes = alarmTimes
        self.memo = memo
        self.recommendedRoutines = recommendedRoutines
        self.isFinish = isFinish
    }
}
