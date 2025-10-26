import TDDomain
import Foundation

public struct EventDetailDTO: Decodable {
    public let eventsDetailId: Int
    public let eventsId: Int
    public let routingUrl: String
    public let eventsDetailImgUrl: [String]?
    
    func convertToEventDetail() -> TDEventDetail {
        TDEventDetail(
            eventsDetailId: eventsDetailId,
            eventsId: eventsId,
            routingURL: URL(string: routingUrl),
            imageURLs: eventsDetailImgUrl?.compactMap { URL(string: $0) } ?? []
        )
    }
}
