import TDDomain
import Foundation
import TDCore

public struct EventListDTO: Decodable {
    public let eventsDtos: [EventDTO]
}

public struct EventDTO: Decodable, Sendable {
    public let id: Int
    public let eventName: String
    public let startAt: String
    public let endAt: String
    public let thumbUrl: String
    public let appVersion: String
    
    func convertToEvent() -> TDEvent {
        TDEvent(
            id: id,
            name: eventName,
            start: Date.convertFromString(startAt, format: .serverDate) ?? Date() ,
            end: Date.convertFromString(endAt, format: .serverDate) ?? Date(),
            thumbURL: URL(string: thumbUrl),
            minAppVersion: appVersion
        )
    }
}
