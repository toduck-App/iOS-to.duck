public protocol FetchEventsUseCase {
    func execute() async -> [TDEvent]
}

final class FetchEventsUseCaseImpl: FetchEventsUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func execute() async -> [TDEvent] {
        do {
            return try await repository.fetchEvents()
                .filter { $0.isActive() }
        } catch {
            return []
        }
    }
}
