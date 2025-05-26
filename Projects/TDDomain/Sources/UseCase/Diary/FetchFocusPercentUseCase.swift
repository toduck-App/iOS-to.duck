public protocol FetchFocusPercentUseCase {
    func execute(yearMonth: String) async throws -> Int
}

public final class FetchFocusPercentUseCaseImpl: FetchFocusPercentUseCase {
    private let repository: FocusRepository
    
    public init(repository: FocusRepository) {
        self.repository = repository
    }
    
    public func execute(yearMonth: String) async throws -> Int {
        try await repository.fetchFocusPercent(yearMonth: yearMonth)
    }
}
