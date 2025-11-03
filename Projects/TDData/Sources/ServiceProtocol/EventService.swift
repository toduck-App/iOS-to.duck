import Foundation

// MARK: - Service Protocol
public protocol EventService {
    func fetchEvents() async throws -> [EventDTO]
    func fetchEventDetails(eventId: Int) async throws -> [EventDetailDTO]
    func hasParticipated() async throws -> Bool
    func participate(socialId: Int, phone: String) async throws
}
