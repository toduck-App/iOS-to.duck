public protocol DiaryRepository {
    func createDiary(diary: Diary) async throws
    func fetchDiaryList(year: Int, month: Int) async throws -> [Diary]
}
