//
//  DeleteScheduleUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

public final class DeleteScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute(scheduleId: Int) async throws -> Bool {
        return try await scheduleRepository.deleteSchedule(scheduleId: scheduleId)
    }
}
