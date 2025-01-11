import Foundation

public protocol DeleteDiaryUseCase {
    func execute(id: Diary.ID) async throws -> Bool
}

public final class DeleteDiaryUseCaseImpl: DeleteDiaryUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(id: Diary.ID) async throws -> Bool {
        return try await repository.deleteDiary(id: id)
    }
}
