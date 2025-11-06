import Foundation

public struct SocialCursor {
    public private(set) var nextCursor: Int?
    public private(set) var hasMore: Bool

    public init(nextCursor: Int? = nil, hasMore: Bool = true) {
        self.nextCursor = nextCursor
        self.hasMore = hasMore
    }

    public mutating func update(with result: (hasMore: Bool, nextCursor: Int?)) {
        hasMore = result.hasMore
        nextCursor = result.nextCursor
    }

    public mutating func reset() {
        nextCursor = nil
        hasMore = true
    }
}
