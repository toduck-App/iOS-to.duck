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
    private let routineListRepository: RoutineRepositoryProtocol
    
    public init(routineListRepository: RoutineRepositoryProtocol) {
        self.routineListRepository = routineListRepository
    }
    
    public func execute() async throws -> [Routine] {
        return try await routineListRepository.fetchRoutineList()
    }
}
