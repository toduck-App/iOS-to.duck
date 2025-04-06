import Foundation
import TDCore
import TDDomain

public struct DiaryListResponseDTO: Decodable {
    public let diaryDtos: [DiaryDTO]
    
    func convertToDiaryList() -> [Diary] {
        return diaryDtos.map {
            Diary(
                id: $0.diaryId,
                date: Date.convertFromString($0.date, format: .yearMonthDay) ?? Date(),
                emotion: Emotion(rawValue: $0.emotion) ?? .happy,
                title: $0.title ?? "",
                memo: $0.memo ?? "",
                diaryImageUrls: $0.diaryImages?.map { $0.url }
            )
        }
    }
}

public struct DiaryDTO: Decodable {
    public let diaryId: Int
    public let date: String
    public let emotion: String
    public let title: String?
    public let memo: String?
    public let diaryImages: [DiaryImageDTO]?
}

public struct DiaryImageDTO: Decodable {
    public let diaryImageId: Int
    public let url: String
}
