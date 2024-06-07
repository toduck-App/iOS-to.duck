//
//  FetchRoutineListUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class FetchRoutineListUseCase {
    private let routineListRepository: RoutineListRepositoryProtocol
    
    init(routineListRepository: RoutineListRepositoryProtocol) {
        self.routineListRepository = routineListRepository
    }
    
    func execute() async throws -> [Routine] {
        return try await routineListRepository.fetchRoutineList()
    }
}
