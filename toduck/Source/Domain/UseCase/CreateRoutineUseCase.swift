//
//  CreateRoutineList.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class CreateRoutineUseCase {
    private let routineRepository: RoutineRepositoryProtocol
    
    init(routineRepository: RoutineRepositoryProtocol) {
        self.routineRepository = routineRepository
    }
    
    // 매개변수 추가 필요
    func execute() async throws -> Bool {
        return try await routineRepository.createRoutine()
    }
}
