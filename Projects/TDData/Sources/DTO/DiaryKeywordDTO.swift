import TDDomain
import Foundation

public struct DiaryKeywordDTO: Codable, Hashable {
    public let keywordId: Int
    public let keywordName: String
    
    public init(keywordId: Int, keywordName: String) {
        self.keywordId = keywordId
        self.keywordName = keywordName
    }
}

extension DiaryKeywordDTO {
    func toDomain() -> DiaryKeyword {
        DiaryKeyword(id: keywordId, keywordName: keywordName)
    }
}
