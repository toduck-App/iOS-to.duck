//
//  ScheduleRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import TDDomain
import Foundation

public final class ScheduleRepositoryImpl: ScheduleRepository {
    public init() { }
    
    public func fetchSchedule() async throws -> Schedule {
        return Schedule(
            title: "캐릭터 디자인 작업",
            category: TDCategory(colorHex: "#123456", imageIndex: 1),
            isAllDay: false,
            date: nil,
            time: nil,
            repeatDays: nil,
            alarmTimes: nil,
            place: nil,
            memo: nil,
            isFinish: false
        )
    }
    
    public func fetchScheduleList() async throws -> [Schedule] {
        return [
            Schedule(
                title: "캐릭터 디자인 작업",
                category: TDCategory(colorHex: "#123456", imageIndex: 0),
                isAllDay: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinish: false
            )
        ]
    }
    
    public func moveTomorrowSchedule(scheduleId: Int) async throws -> Bool {
        return false
    }
    
    public func createSchedule(schedule: Schedule) async throws -> Bool {
        return false
    }
    
    
    public func updateSchedule(scheduleId: Int) async throws -> Bool {
        return false
    }
    
    public func deleteSchedule(scheduleId: Int) async throws -> Bool {
        return false
    }
}
