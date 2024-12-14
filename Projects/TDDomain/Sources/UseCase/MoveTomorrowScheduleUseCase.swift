//
//  moveTomorrowRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

public final class MoveTomorrowScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute(scheduleId: Int) async throws -> Bool {
        return try await scheduleRepository.moveTomorrowSchedule(scheduleId: scheduleId)
    }
}
