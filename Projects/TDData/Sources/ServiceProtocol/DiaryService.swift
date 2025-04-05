import TDCore
import TDDomain

public protocol DiaryService {
    func createDiary(diary: DiaryPostRequestDTO) async throws
    func fetchDiaryList(year: Int, month: Int) async throws -> DiaryListResponseDTO
    func updateDiary(diary: DiaryPatchRequestDTO) async throws
    func deleteDiary(id: Int) async throws
    func fetchDiaryCompareCount(year: Int, month: Int) async throws -> Int
}
