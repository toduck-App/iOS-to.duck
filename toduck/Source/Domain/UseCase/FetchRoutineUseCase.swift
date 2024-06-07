//
//  FetchRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

final class FetchRoutineUseCase {
    private let routineRepository: RoutineRepository
    
    init(routineRepository: RoutineRepository) {
        self.routineRepository = routineRepository
    }
    
    func execute() async throws -> Routine {
        return try await routineRepository.fetchRoutine()
    }
}
