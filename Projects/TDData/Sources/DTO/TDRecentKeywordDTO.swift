import Foundation
import TDDomain

public struct TDRecentKeywordDTO: Codable {
    public var id: UUID = UUID()
    public let date: Date
    public let keyword: String
    
    public init(date: Date, keyword: String) {
        self.date = date
        self.keyword = keyword
    }
}

extension TDRecentKeywordDTO {
    func convertToTDRecentKeywordDTO() -> Keyword {
        return Keyword(date: date, word: keyword)
    }
}
