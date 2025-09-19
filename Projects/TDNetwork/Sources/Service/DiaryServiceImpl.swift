import Foundation
import TDCore
import TDData
import TDDomain

public struct DiaryServiceImpl: DiaryService {
    private let provider: MFProvider<DiaryAPI>
    
    public init(provider: MFProvider<DiaryAPI> = MFProvider<DiaryAPI>()) {
        self.provider = provider
    }
    
    public func createDiary(diary: DiaryPostRequestDTO) async throws {
        let target = DiaryAPI.createDiary(diary: diary)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func fetchDiaryList(year: Int, month: Int) async throws -> DiaryListResponseDTO {
        let monthString = String(format: "%02d", month)
        let yearMonth = "\(year)-\(monthString)"
        let target = DiaryAPI.fetchDiaryList(yearMonth: yearMonth)
        let response = try await provider.requestDecodable(of: DiaryListResponseDTO.self, target)
        
        return response.value
    }
    
    public func updateDiary(diary: TDData.DiaryPatchRequestDTO) async throws {
        let target = DiaryAPI.updateDiary(diary: diary)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func deleteDiary(id: Int) async throws {
        let target = DiaryAPI.deleteDiary(id: id)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func fetchDiaryCompareCount(yearMonth: String) async throws -> Int {
        let target = DiaryAPI.compareDiaryCount(yearMonth: yearMonth)
        let response = try await provider.requestDecodable(of: DiaryCompareCountResponseDTO.self, target)
        return response.value.count
    }
    
    public func fetchStreak() async throws -> DiaryStreakResponseDTO {
        let target = DiaryAPI.fetchStreak
        let response = try await provider.requestDecodable(of: DiaryStreakResponseDTO.self, target)
        return response.value
    }
}
