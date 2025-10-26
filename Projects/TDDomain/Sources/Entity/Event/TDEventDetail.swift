import Foundation

public struct TDEventDetail: Identifiable, Equatable {
    public var id: Int { eventsDetailId }
    public let eventsDetailId: Int
    public let eventsId: Int
    public let routingURL: URL?
    public let imageURLs: [URL]
    
    public init(eventsDetailId: Int, eventsId: Int, routingURL: URL?, imageURLs: [URL]) {
        self.eventsDetailId = eventsDetailId
        self.eventsId = eventsId
        self.routingURL = routingURL
        self.imageURLs = imageURLs
    }
}
