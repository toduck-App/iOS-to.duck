//
//  moveTomorrowRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class MoveTomorrowRoutineUseCase {
    private let routineRepository: RoutineRepositoryProtocol
    
    init(routineRepository: RoutineRepositoryProtocol) {
        self.routineRepository = routineRepository
    }
    
    func execute(routineId: Int) async throws -> Bool {
        return try await routineRepository.moveTomorrowRoutine(routineId: routineId)
    }
}
