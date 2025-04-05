public struct DiaryPatchRequestDTO: Encodable {
    public let id: Int
    public let isChangeEmotion: Bool
    public let emotion, title, memo: String
    public let diaryImageUrls: [String]
}
