import TDDomain
import Foundation

public final class DiaryRepositoryImpl: DiaryRepository {
    
    private let service: DiaryService
    
    public init(service: DiaryService) {
        self.service = service
    }
    
    public func createDiary(diary: Diary) async throws {
        try await service.createDiary(diary: DiaryPostRequestDTO(diary: diary))
    }
    
    public func fetchDiaryList(year: Int, month: Int) async throws -> [Diary] {
        let response = try await service.fetchDiaryList(year: year, month: month)
        
        return response.convertToDiaryList()
    }
    
    
    public func updateDiary(isChangeEmotion: Bool, diary: TDDomain.Diary) async throws {
        let diary = DiaryPatchRequestDTO(isChangeEmotion: isChangeEmotion, diary: diary)
        try await service.updateDiary(diary: diary)
    }
}
