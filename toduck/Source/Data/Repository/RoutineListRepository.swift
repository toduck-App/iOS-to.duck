//
//  RoutineListRepository.swift
//  toduck
//
//  Created by 박효준 on 6/7/24.
//

import Foundation

final class RoutineListRepository: RoutineListRepositoryProtocol {
    func fetchRoutineList() async throws -> [Routine] {
        return [Routine(id: 1, title: "title", isPublic: false, isRepeating: false, isRepeatAllDay: false, alarm: false, isFinish: false)]
    }
    

}
