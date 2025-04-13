import Foundation

public protocol DiaryRepository {
    func createDiary(diary: Diary, image: [(fileName: String, imageData: Data)]?) async throws
    func fetchDiaryList(year: Int, month: Int) async throws -> [Diary]
    func updateDiary(isChangeEmotion: Bool, diary: Diary) async throws
    func deleteDiary(id: Int) async throws
    func fetchDiaryCompareCount(year: Int, month: Int) async throws -> Int
}
