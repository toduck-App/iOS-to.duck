public protocol FetchDiaryListUseCase {
    func execute(year: Int, month: Int) async throws -> [Diary]
}

public final class FetchDiaryListUseCaseImpl: FetchDiaryListUseCase {
    private let repository: DiaryRepository
    
    public init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    public func execute(year: Int, month: Int) async throws -> [Diary] {
        let diaryList = try await repository.fetchDiaryList(year: year, month: month)
        return diaryList
    }
}
