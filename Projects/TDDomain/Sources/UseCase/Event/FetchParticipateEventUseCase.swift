public protocol FetchParticipateEventUseCase {
    func execute() async -> Bool
}

final class FetchParticipateEventUseCaseImpl: FetchParticipateEventUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func execute() async -> Bool {
        do {
            return try await repository.hasParticipated()
        } catch {
            return false
        }
    }
}
