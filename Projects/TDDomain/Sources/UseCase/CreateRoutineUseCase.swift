//
//  CreateRoutine.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

public final class CreateRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routine: Routine) async throws -> Bool {
        return try await repository.createRoutine(routine: routine)
    }
}
