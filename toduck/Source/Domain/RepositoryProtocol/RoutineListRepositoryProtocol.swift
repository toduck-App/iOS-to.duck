//
//  RoutineRepositoryProtocol.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

// MARK: 루틴 리스트 불러오기
protocol RoutineListRepositoryProtocol {
    func fetchRoutineList() async throws -> [Routine]
}
