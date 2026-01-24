import Foundation

public struct TDEventDetail: Identifiable, Equatable {
    public var id: Int { eventsDetailId }
    public let eventsDetailId: Int
    public let eventsId: Int
    public let routingURL: URL?
    public let isButtonVisible: Bool
    public let buttonText: String?
    public let imageURLs: [URL]

    public init(
        eventsDetailId: Int,
        eventsId: Int,
        routingURL: URL?,
        isButtonVisible: Bool,
        buttonText: String?,
        imageURLs: [URL]
    ) {
        self.eventsDetailId = eventsDetailId
        self.eventsId = eventsId
        self.routingURL = routingURL
        self.isButtonVisible = isButtonVisible
        self.buttonText = buttonText
        self.imageURLs = imageURLs
    }
}
