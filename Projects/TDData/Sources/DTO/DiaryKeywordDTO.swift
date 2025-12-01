import TDDomain
import Foundation

public struct DiaryKeywordDTO: Codable, Hashable {
    public let id: UUID
    public let name: String
    public let category: String
    
    public init(id: UUID, name: String, category: String) {
        self.id = id
        self.name = name
        self.category = category
    }
}

extension DiaryKeywordDTO {
    func toDomain() -> TDDomain.DiaryKeyword {
        return DiaryKeyword(
            id: id,
            name: name,
            category: .init(rawValue: category),
            isCustom: true
        )
    }
}
