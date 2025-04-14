import TDData

public struct FocusServiceImpl: FocusService {
    private let provider: MFProvider<FocusAPI>
    
    public init(provider: MFProvider<FocusAPI> = MFProvider<FocusAPI>()) {
        self.provider = provider
    }
    
    public func fetchFocusPrecent(yearMonth: String) async throws -> FocusPercentResponseDTO {
        let target = FocusAPI.fetchFocusPercent(yearMonth: yearMonth)
        let response = try await provider.requestDecodable(of: FocusPercentResponseDTO.self, target)
        
        return response.value
    }
}
