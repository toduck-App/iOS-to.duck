import Foundation

public protocol DiaryRepository {
    func fetchDiary(id: Diary.ID) async throws -> Diary
    func fetchDiaryList(from startDate: Date, to endDate: Date) async throws -> [Diary]
    func createDiary(diary: Diary) async throws -> Diary
    func updateDiary(diary: Diary) async throws -> Diary
    func deleteDiary(id: Diary.ID) async throws -> Bool
}
