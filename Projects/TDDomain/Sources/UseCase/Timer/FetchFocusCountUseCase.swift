public protocol FetchFocusCountUseCase {
    func execute() -> Int
}

final class FetchFocusCountImpl: FetchFocusCountUseCase {
    private let repository: TimerRepository

    public init(repository: TimerRepository) {
        self.repository = repository
    }

    public func execute() -> Int {
        return repository.fetchFocusCount()
    }
}
