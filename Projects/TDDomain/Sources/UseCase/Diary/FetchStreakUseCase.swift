public protocol FetchStreakUseCase {
    func execute() async throws -> (streak: Int, lastWriteDate: String?)
}

public final class FetchStreakUseCaseImpl: FetchStreakUseCase {
    private let repository: DiaryRepository
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> (streak: Int, lastWriteDate: String?) {
        try await repository.fetchStreak()
    }
}
