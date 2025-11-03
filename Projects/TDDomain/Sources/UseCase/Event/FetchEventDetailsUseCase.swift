public protocol FetchEventDetailsUseCase {
    func execute(eventId: Int) async throws -> TDEventDetail?
}

final class FetchEventDetailsUseCaseImpl: FetchEventDetailsUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func execute(eventId: Int) async throws -> TDEventDetail? {
        try await repository.fetchEventDetails(eventId: eventId)
    }
}
