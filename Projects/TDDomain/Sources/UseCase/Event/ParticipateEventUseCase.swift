public protocol ParticipateEventUseCase {
    func execute(socialId: Int, phone: String) async throws
}

final class ParticipateEventUseCaseImpl: ParticipateEventUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func execute(socialId: Int, phone: String) async throws {
        try await repository.participate(socialId: socialId, phone: phone)
    }
}
