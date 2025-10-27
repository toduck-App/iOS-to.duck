import Foundation
import TDCore
import TDData

public struct EventServiceImpl: EventService {
    private let provider: MFProvider<EventAPI>

    public init(provider: MFProvider<EventAPI> = MFProvider<EventAPI>()) {
        self.provider = provider
    }
    
    public func fetchEvents() async throws -> [EventDTO] {
        let target = EventAPI.fetchEvents
        let response = try await provider.requestDecodable(of: EventListDTO.self, target)
        return response.value.eventsDtos
    }
    
    public func fetchEventDetails(eventId: Int) async throws -> [EventDetailDTO] {
        let target = EventAPI.fetchEventDetails
        let response = try await provider.requestDecodable(of: EventDetailListDTO.self, target)
        return response.value.eventsDetailDtos
    }
    
    public func hasParticipated() async throws -> Bool {
        let target = EventAPI.fetchEvents
        let response = try await provider.requestDecodable(of: ParticipationCheckContentDTO.self, target)
        return response.value.participated
    }
    
    public func participate(socialId: Int, phone: String) async throws {
        let target = EventAPI.participate(id: socialId, phone: phone)
        try await provider.requestDecodable(of: EventDTO.self, target)
    }
    
}
