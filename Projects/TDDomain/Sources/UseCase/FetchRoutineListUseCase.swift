//
//  FetchRoutineListUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

public protocol FetchRoutineListUseCase {
    func execute() async throws -> [Routine]
}

public final class FetchRoutineListUseCaseImpl: FetchRoutineListUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Routine] {
        return try await repository.fetchRoutineList()
    }
}
