public struct DiaryPatchRequestDTO: Decodable {
    public let id: Int
    public let isChangeEmotion: Bool
    public let emotion, title, memo: String
    public let diaryImageUrls: [String]
}
