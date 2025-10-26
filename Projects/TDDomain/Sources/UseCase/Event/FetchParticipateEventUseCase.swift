public protocol FetchParticipateEventUseCase {
    func execute() async throws -> Bool
}

final class FetchParticipateEventUseCaseImpl: FetchParticipateEventUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func execute() async throws -> Bool {
        try await repository.hasParticipated()
    }
}
