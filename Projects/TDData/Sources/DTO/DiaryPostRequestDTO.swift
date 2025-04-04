public struct DiaryPostRequestDTO: Decodable {
    public let date, emotion, title, memo: String
    public let diaryImageUrls: [String]
}
