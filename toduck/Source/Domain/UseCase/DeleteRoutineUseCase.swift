//
//  DeleteRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

final class DeleteRoutineUseCase {
    private let routineRepository: RoutineRepositoryProtocol
    
    init(routineRepository: RoutineRepositoryProtocol) {
        self.routineRepository = routineRepository
    }
    
    func execute(routineID: Int) async throws -> Bool {
        return try await routineRepository.deleteRoutine(routineId: routineID)
    }
}
