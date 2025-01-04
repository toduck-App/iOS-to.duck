import Foundation

public protocol UpdateDiaryUseCase {
    func execute(diary: Diary) async throws -> Diary
}

public final class UpdateDiaryUseCaseImpl: UpdateDiaryUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }

    public func execute(diary: Diary) async throws -> Diary {
        try await repository.updateDiary(diary: diary)
    }
}
