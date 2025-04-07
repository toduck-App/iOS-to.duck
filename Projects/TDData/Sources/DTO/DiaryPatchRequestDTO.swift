import TDDomain
public struct DiaryPatchRequestDTO: Encodable {
    public let id: Int
    public let isChangeEmotion: Bool
    public let emotion, title, memo: String
    public let diaryImageUrls: [String]
    
    public init(
        isChangeEmotion: Bool,
        diary: Diary
    ) {
        self.id = diary.id
        self.isChangeEmotion = isChangeEmotion
        self.emotion = diary.emotion.rawValue
        self.title = diary.title
        self.memo = diary.memo
        self.diaryImageUrls = diary.diaryImageUrls ?? []
    }
}
