//
//  UpdateDiaryUseCase.swift
//  toduck
//
//  Created by 승재 on 6/10/24.
//

import Foundation

public final class UpdateDiaryUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(diary: Diary) async throws -> Diary {
        return try await repository.updateDiary(diary: diary)
    }
}
