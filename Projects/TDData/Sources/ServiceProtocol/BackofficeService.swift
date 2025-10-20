import TDCore
import TDDomain

public protocol BackofficeService {
    func validateVersion(_ version: String) async throws -> ValidateVersionDTO
}
