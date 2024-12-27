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
            category: TDCategory(colorType: .back1, imageType: .computer),
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
                category: TDCategory(colorType: .back1, imageType: .computer),
                isAllDay: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinish: false
            ),
            Schedule(
                title: "토익 공부",
                category: TDCategory(colorType: .back2, imageType: .food),
                isAllDay: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinish: true
            ),
            Schedule(
                title: "영화 보기",
                category: TDCategory(colorType: .back3, imageType: .medicine),
                isAllDay: true,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: "경북 구미시",
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
