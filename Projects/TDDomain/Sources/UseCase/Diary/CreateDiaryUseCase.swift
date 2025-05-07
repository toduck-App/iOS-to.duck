import Foundation

public protocol CreateDiaryUseCase {
    func execute(diary: Diary, image: [(fileName: String, imageData: Data)]?) async throws
}

final class CreateDiaryUseCaseImpl: CreateDiaryUseCase {
    private let repository: DiaryRepository

    init(repository: DiaryRepository) {
        self.repository = repository
    }

    func execute(
        diary: Diary,
        image: [(fileName: String, imageData: Data)]?
    ) async throws {
        try await repository.createDiary(diary: diary, image: image)
    }
}
