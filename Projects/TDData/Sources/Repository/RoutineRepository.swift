//
//  RoutineRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import TDDomain
import Foundation

public final class RoutineRepository: RoutineRepositoryProtocol {
    public init() { }
    
    public func fetchRoutineList() async throws -> [Routine] {
        return [Routine(id: UUID(), title: "123", category: TDCategory(colorType: .back1, imageType: .computer), isAllDay: false, isPublic: true, date: Date(), time: nil, repeatDays: nil, alarmTimes: nil, memo: nil, recommendedRoutines: nil, isFinish: false)]
    }
    
    public func createRoutine(routine: Routine) async throws -> Bool {
        return false
    }
    
    public func fetchRoutine() async throws -> Routine {
        return Routine(id: UUID(), title: "123", category: TDCategory(colorType: .back1, imageType: .computer), isAllDay: false, isPublic: true, date: Date(), time: nil, repeatDays: nil, alarmTimes: nil, memo: nil, recommendedRoutines: nil, isFinish: false)
    }
    
    public func updateRoutine(routineId: Int) async throws -> Bool {
        return false
    }
    
    public func deleteRoutine(routineId: Int) async throws -> Bool {
        return false
    }
}
