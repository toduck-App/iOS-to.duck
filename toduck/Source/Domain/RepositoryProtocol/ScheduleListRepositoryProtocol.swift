//
//  ScheduleRepositoryProtocol.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

// MARK: 일정 리스트 불러오기
protocol ScheduleListRepositoryProtocol {
    func fetchScheduleList() async throws -> [Schedule]
}
