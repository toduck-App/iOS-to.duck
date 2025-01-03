//
//  FetchRoutineUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

public final class FetchRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> Routine {
        return try await repository.fetchRoutine()
    }
}
