public protocol DeleteDiaryUseCase {
    func execute(id: Int) async throws
}

public final class DeleteDiaryUseCaseImpl: DeleteDiaryUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(id: Int) async throws {
        try await repository.deleteDiary(id: id)
    }
}
