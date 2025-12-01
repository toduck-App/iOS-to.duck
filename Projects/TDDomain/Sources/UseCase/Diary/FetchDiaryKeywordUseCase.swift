//
//  FetchDiaryKeywordUseCase.swift
//  TDDomain
//
//  Created by 승재 on 11/16/25.
//

import Foundation

public protocol FetchDiaryKeywordUseCase {
    func execute() -> DiaryKeywordDictionary
}

final class FetchDiaryKeywordUseCaseImpl: FetchDiaryKeywordUseCase {
    private let repository: DiaryRepository

    init(repository: DiaryRepository) {
        self.repository = repository
    }

    func execute() -> DiaryKeywordDictionary {
        return repository.fetchDiaryKeyword()
    }
}
