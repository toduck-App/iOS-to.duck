import Foundation

/// 소셜에서 사용되는 최근 검색어입니다.
public struct Keyword: Identifiable, Hashable {
    public let id = UUID()
    public let date: Date
    public let word: String
    
    public init(date: Date, word: String) {
        self.date = date
        self.word = word
    }
}
