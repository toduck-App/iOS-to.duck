import Foundation
import TDCore
import TDDomain

public struct BackofficeRepositoryImpl: BackofficeRepository {
    private let service: BackofficeService

    public init(service: BackofficeService) {
        self.service = service
    }

    public func validateVersion(_ version: String) async throws -> VersionPolicy {
        let response = try await service.validateVersion(version)
        return VersionPolicy(name: response.updateStatus)
    }
}
