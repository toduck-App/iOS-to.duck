import Foundation

public protocol DiaryRepository {
    func createDiary(diary: Diary, image: [(fileName: String, imageData: Data)]?) async throws
    func fetchDiaryList(year: Int, month: Int) async throws -> [Diary]
    func updateDiary(isChangeEmotion: Bool, diary: Diary, image: [(fileName: String, imageData: Data)]?) async throws
    func deleteDiary(id: Int) async throws
    func fetchDiaryCompareCount(yearMonth: String) async throws -> Int
    func fetchStreak() async throws -> (streak: Int, lastWriteDate: String?)
    func fetchDiaryKeyword() -> DiaryKeywordDictionary
    func saveDiaryKeyword(name: String, category: DiaryKeywordCategory) throws
    func deleteDiaryKeywords(keywords: [DiaryKeyword]) throws
}
