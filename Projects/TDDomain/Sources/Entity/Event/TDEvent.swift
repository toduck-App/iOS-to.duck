import Foundation

public struct TDEvent: Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let start: Date
    public let end: Date
    public let thumbURL: URL?
    public let minAppVersion: String?
    
    public init(
        id: Int,
        name: String,
        start: Date,
        end: Date,
        thumbURL: URL?,
        minAppVersion: String?
    ) {
        self.id = id
        self.name = name
        self.start = start
        self.end = end
        self.thumbURL = thumbURL
        self.minAppVersion = minAppVersion
    }
    
    func isActive(reference: Date = Date()) -> Bool {
        return reference >= start && reference <= end
    }
}
