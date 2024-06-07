//
//  RoutineRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class RoutineRepository: RoutineRepositoryProtocol {
    
    func fetchRoutine() async throws -> Routine {
        <#code#>
    }
    
    func updateRoutine(routineId: Int) async throws -> Bool {
        <#code#>
    }
    
    func deleteRoutine(routineId: Int) async throws -> Bool {
        <#code#>
    }
    
    func moveTomorrowRoutine(routineId: Int) async throws -> Bool {
        <#code#>
    }
    
    // 매개변수 수정
    func createRoutine() async throws -> Bool {
        return true
    }
}
