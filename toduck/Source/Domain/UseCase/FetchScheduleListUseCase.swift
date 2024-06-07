//
//  FetchScheduleUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

final class FetchScheduleListUseCase {
    private let scheduleListRepository: ScheduleListRepositoryProtocol
    
    init(scheduleListRepository: ScheduleListRepositoryProtocol) {
        self.scheduleListRepository = scheduleListRepository
    }
    
    func execute() async throws -> [Schedule] {
        return try await scheduleListRepository.fetchScheduleList()
    }
}
