//
//  RoutineRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

public final class RoutineRepository: RoutineRepositoryProtocol {
    public func fetchRoutineList() async throws -> [Routine] {
        <#code#>
    }
    
    public func createRoutine(routine: Routine) async throws -> Bool {
        <#code#>
    }
    
    public func fetchRoutine() async throws -> Routine {
        <#code#>
    }
    
    public func updateRoutine(routineId: Int) async throws -> Bool {
        <#code#>
    }
    
    public func deleteRoutine(routineId: Int) async throws -> Bool {
        <#code#>
    }
}
