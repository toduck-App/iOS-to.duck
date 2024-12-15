//
//  FetchScheduleListUseCase.swift
//  toduck
//
//  Created by 박효준 on 6/6/24.
//

import Foundation

public protocol FetchScheduleListUseCase {
    func execute() async throws -> [Schedule]
}

public final class FetchScheduleListUseCaseImpl: FetchScheduleListUseCase {
    private let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Schedule] {
        return try await repository.fetchScheduleList()
    }
}
