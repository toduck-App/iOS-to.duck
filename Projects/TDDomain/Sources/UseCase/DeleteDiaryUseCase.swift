//
//  DeleteDiaryUseCase.swift
//  toduck
//
//  Created by 승재 on 6/10/24.
//

import Foundation

public final class DeleteDiaryUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(id: Int) async throws -> Bool {
        return try await repository.deleteDiary(id: id)
    }
}
