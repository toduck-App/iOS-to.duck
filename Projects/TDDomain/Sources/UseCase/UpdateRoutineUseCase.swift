//
//  UpdateRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

public final class UpdateRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int) async throws -> Bool {
        return try await repository.updateRoutine(routineId: routineId)
    }
}
