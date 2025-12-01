import Foundation

public protocol DeleteDiaryKeywordUseCase {
    func execute(keywords: [DiaryKeyword]) throws
}

final class DeleteDiaryKeywordUseCaseImpl: DeleteDiaryKeywordUseCase {
    private let repository: DiaryRepository

    init(repository: DiaryRepository) {
        self.repository = repository
    }

    func execute(keywords: [DiaryKeyword]) throws {
        try repository.deleteDiaryKeywords(keywords: keywords)
    }
}
