//
//  FetchScheduleUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

public final class FetchScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute() async throws -> Schedule {
        return try await scheduleRepository.fetchSchedule()
    }
}
