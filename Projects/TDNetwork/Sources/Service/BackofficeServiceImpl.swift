import TDCore
import TDData

public struct BackofficeServiceImpl: BackofficeService {
    private let provider: MFProvider<BackofficeAPI>
    
    public init(provider: MFProvider<BackofficeAPI> = MFProvider<BackofficeAPI>()) {
        self.provider = provider
    }
    
    public func validateVersion(_ version: String) async throws -> ValidateVersionDTO {
        let target = BackofficeAPI.validateVersion(version: version)
        return try await provider.requestDecodable(of: ValidateVersionDTO.self, target).value
    }
}
