public protocol FetchFocusCountUseCase {
    func execute() -> Int
}

final class FetchFocusCountImpl: FetchFocusCountUseCase {
    private let repository: FocusRepository

    public init(repository: FocusRepository) {
        self.repository = repository
    }

    public func execute() -> Int {
        return repository.fetchFocusCount()
    }
}
