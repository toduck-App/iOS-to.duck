//
//  CreateScheduleList.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class CreateScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    // 매개변수 추가 필요
    func execute() async throws -> Bool {
        return try await scheduleRepository.createSchedule()
    }
}
