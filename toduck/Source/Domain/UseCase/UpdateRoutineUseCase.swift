//
//  UpdateRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

final class UpdateRoutineUseCase {
    private let routineRepository: RoutineRepositoryProtocol
    
    init(routineRepository: RoutineRepositoryProtocol) {
        self.routineRepository = routineRepository
    }
    
    func execute(routineId: Int) async throws -> Bool {
        return try await routineRepository.updateRoutine(routineId: routineId)
    }
}
