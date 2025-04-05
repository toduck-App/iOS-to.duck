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
        let target = DiaryAPI.fetchDiaryList(year: year, month: month)
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
    
    public func fetchDiaryCompareCount(year: Int, month: Int) async throws -> Int {
        let target = DiaryAPI.compareDiaryCount(year: year, month: month)
        let response = try await provider.requestDecodable(of: DiaryCompareCountResponseDTO.self, target)
        return response.value.count
    }
}
