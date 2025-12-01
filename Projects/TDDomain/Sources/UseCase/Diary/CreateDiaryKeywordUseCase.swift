import Foundation

public protocol CreateDiaryKeywordUseCase {
    func execute(name: String, category: DiaryKeywordCategory) throws
}

final class CreateDiaryKeywordUseCaseImpl: CreateDiaryKeywordUseCase {
    private let repository: DiaryRepository

    init(repository: DiaryRepository) {
        self.repository = repository
    }

    func execute(name: String, category: DiaryKeywordCategory) throws {
        try repository.saveDiaryKeyword(name: name, category: category)
    }
}
