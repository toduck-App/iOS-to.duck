//
//  RoutineRepositoryProtocol.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

// MARK: 루틴 하나 상세 불러오기
protocol RoutineRepositoryProtocol {
    func fetchRoutine() async throws -> Routine
    func updateRoutine(routineId: Int) async throws -> Bool
    func deleteRoutine(routineId: Int) async throws -> Bool
    func moveTomorrowRoutine(routineId: Int) async throws -> Bool
    // create 매개변수 추가 필요
    func createRoutine() async throws -> Bool
}
