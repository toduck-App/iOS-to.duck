import TDData

public struct FocusServiceImpl: FocusService {
    private let provider: MFProvider<FocusAPI>
    
    public init(provider: MFProvider<FocusAPI> = MFProvider<FocusAPI>()) {
        self.provider = provider
    }
    
    public func fetchFocusPercent(yearMonth: String) async throws -> FocusPercentResponseDTO {
        let target = FocusAPI.fetchFocusPercent(yearMonth: yearMonth)
        let response = try await provider.requestDecodable(of: FocusPercentResponseDTO.self, target)
        
        return response.value
    }
    
    public func fetchFocusList(yearMonth: String) async throws -> FocusListResponseDTO {
        let target = FocusAPI.fetchFocusList(yearMonth: yearMonth)
        let response = try await provider.requestDecodable(of: FocusListResponseDTO.self, target)
        
        return response.value
    }
}
