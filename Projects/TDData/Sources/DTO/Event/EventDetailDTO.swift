import TDDomain
import Foundation

public struct EventDetailListDTO: Decodable {
    public let eventsDetailDtos: [EventDetailDTO]
}

public struct EventDetailDTO: Decodable {
    public let eventsDetailId: Int
    public let eventsId: Int
    public let routingUrl: String
    public let buttonVisible: Bool
    public let buttonText: String
    public let eventsDetailImgUrl: [String]?

    func convertToEventDetail() -> TDEventDetail {
        TDEventDetail(
            eventsDetailId: eventsDetailId,
            eventsId: eventsId,
            routingURL: URL(string: routingUrl),
            isButtonVisible: buttonVisible,
            buttonText: buttonText,
            imageURLs: eventsDetailImgUrl?.compactMap { URL(string: $0) } ?? []
        )
    }
}
