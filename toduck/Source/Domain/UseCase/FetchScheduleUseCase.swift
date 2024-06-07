//
//  FetchScheduleUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class FetchScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute() async throws -> Schedule {
        return try await scheduleRepository.fetchSchedule()
    }
}
