//
//  ScheduleRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

public final class ScheduleRepository: ScheduleRepositoryProtocol {
    
    public func fetchSchedule() async throws -> Schedule {
        <#code#>
    }
    
    public func fetchScheduleList() async throws -> [Schedule] {
        <#code#>
    }
    
    public func moveTomorrowSchedule(scheduleId: Int) async throws -> Bool {
        <#code#>
    }
    
    public func createSchedule(schedule: Schedule) async throws -> Bool {
        <#code#>
    }
    
    
    public func updateSchedule(scheduleId: Int) async throws -> Bool {
        <#code#>
    }
    
    public func deleteSchedule(scheduleId: Int) async throws -> Bool {
        <#code#>
    }
}
