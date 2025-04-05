public protocol DiaryRepository {
    func createDiary(diary: Diary) async throws
    func fetchDiaryList(year: Int, month: Int) async throws -> [Diary]
    func updateDiary(isChangeEmotion: Bool, diary: Diary) async throws
    func fetchDiaryCompareCount(year: Int, month: Int) async throws -> Int
}
