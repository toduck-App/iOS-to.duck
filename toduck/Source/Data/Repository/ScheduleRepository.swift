//
//  ScheduleRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class ScheduleRepository: ScheduleRepositoryProtocol {
    func fetchSchedule() async throws -> Schedule {
        <#code#>
    }
    
    func updateSchedule(scheduleId: Int) async throws -> Bool {
        <#code#>
    }
    
    func deleteSchedule(scheduleId: Int) async throws -> Bool {
        <#code#>
    }
    
    // 매개변수 수정
    func createSchedule() async throws -> Bool {
        <#code#>
    }
}
