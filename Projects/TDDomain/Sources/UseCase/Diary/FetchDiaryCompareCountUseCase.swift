public protocol FetchDiaryCompareCountUseCase {
    func execute(yearMonth: String) async throws -> Int
}

public final class FetchDiaryCompareCountUseCaseImpl: FetchDiaryCompareCountUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }

    public func execute(yearMonth: String) async throws -> Int {
        try await repository.fetchDiaryCompareCount(yearMonth: yearMonth)
    }
}

