import Foundation

public protocol FetchDiaryUseCase {
    func execute(id: Diary.ID) async throws -> Diary
    func execute(from startDate: Date, to endDate: Date) async throws -> [Diary]
}

public final class FetchDiaryUseCaseImpl: FetchDiaryUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(id: Diary.ID) async throws -> Diary {
        return try await repository.fetchDiary(id: id)
    }
    
    public func execute(from startDate: Date, to endDate: Date) async throws -> [Diary] {
        return try await repository.fetchDiaryList(from: startDate, to: endDate)
    }
}
