import TDDomain
import Foundation

public struct UserKeywordDtos: Codable, Hashable {
    public let userKeywordDtos: [UserKeywordDTO]
}

public struct UserKeywordDTO: Codable, Hashable {
    public let id: Int
    public let category: String
    public let keyword: String
    
    public init(id: Int, category: String, keyword: String) {
        self.id = id
        self.category = category
        self.keyword = keyword
    }
}

extension UserKeywordDTO {
    func toDomain() -> UserKeyword {
        return UserKeyword(
            id: id,
            name: keyword,
            category: .init(rawValue: category)
        )
    }
}
