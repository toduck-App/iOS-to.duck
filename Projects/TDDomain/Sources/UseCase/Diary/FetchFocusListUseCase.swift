public protocol FetchFocusListUseCase {
    func execute(yearMonth: String) async throws -> [Focus]
}

public final class FetchFocusListUseCaseImpl: FetchFocusListUseCase {
    private let repository: FocusRepository

    public init(repository: FocusRepository) {
        self.repository = repository
    }

    public func execute(yearMonth: String) async throws -> [Focus] {
        try await repository.fetchFocusList(yearMonth: yearMonth)
    }
}
