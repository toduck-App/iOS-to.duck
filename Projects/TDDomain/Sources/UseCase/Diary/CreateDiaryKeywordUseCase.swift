import Foundation

public protocol CreateDiaryKeywordUseCase {
    func execute(name: String, category: UserKeywordCategory) async throws
}

final class CreateDiaryKeywordUseCaseImpl: CreateDiaryKeywordUseCase {
    private let repository: DiaryRepository

    init(repository: DiaryRepository) {
        self.repository = repository
    }

    func execute(name: String, category: UserKeywordCategory) async throws {
        let userKeyword = UserKeyword(id: 0, name: name, category: category)
        try await repository.createDiaryKeyword(keyword: userKeyword)
    }
}
