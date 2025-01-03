//
//  RoutineRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import TDDomain
import Foundation

public final class RoutineRepositoryImpl: RoutineRepository {
    public init() { }
    
    public func fetchRoutineList() async throws -> [Routine] {
        return Routine.dummy
    }
    
    public func createRoutine(routine: Routine) async throws -> Bool {
        return false
    }
    
    public func fetchRoutine() async throws -> Routine {
        return Routine.dummy.first!
    }
    
    public func updateRoutine(routineId: Int) async throws -> Bool {
        return false
    }
    
    public func deleteRoutine(routineId: Int) async throws -> Bool {
        return false
    }
}
