public protocol FetchDiaryCompareCountUseCase {
    func execute(year: Int, month: Int) async throws -> Int
}

public final class FetchDiaryCompareCountUseCaseImpl: FetchDiaryCompareCountUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }

    public func execute(year: Int, month: Int) async throws -> Int {
        try await repository.fetchDiaryCompareCount(year: year, month: month)
    }
}

