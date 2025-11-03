import Foundation

public protocol EventRepository {
    func fetchEvents() async throws -> [TDEvent]
    func fetchEventDetails(eventId: Int) async throws -> TDEventDetail?
    func hasParticipated() async throws -> Bool
    func participate(socialId: Int, phone: String) async throws
}
