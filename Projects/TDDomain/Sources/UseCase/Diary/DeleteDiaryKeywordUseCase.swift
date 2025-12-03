import Foundation

public protocol DeleteDiaryKeywordUseCase {
    func execute(keywords: [UserKeyword]) async throws
}

final class DeleteDiaryKeywordUseCaseImpl: DeleteDiaryKeywordUseCase {
    private let repository: DiaryRepository

    init(repository: DiaryRepository) {
        self.repository = repository
    }

    func execute(keywords: [UserKeyword]) async throws {
        try await repository.deleteDiaryKeywords(keywords: keywords)
    }
}
