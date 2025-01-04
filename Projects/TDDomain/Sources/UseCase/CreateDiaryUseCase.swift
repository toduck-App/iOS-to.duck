import Foundation

public protocol CreateDiaryUseCase {
    func execute(diary: Diary) async throws -> Diary
}

public final class CreateDiaryUseCaseImpl: CreateDiaryUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(diary: Diary) async throws -> Diary {
        return try await repository.createDiary(diary: diary)
    }
}
