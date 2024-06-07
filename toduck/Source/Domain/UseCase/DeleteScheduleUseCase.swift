//
//  DeleteScheduleUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

final class DeleteScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(scheduleId: Int) async throws -> Bool {
        return try await scheduleRepository.deleteSchedule(scheduleId: scheduleId)
    }
}
