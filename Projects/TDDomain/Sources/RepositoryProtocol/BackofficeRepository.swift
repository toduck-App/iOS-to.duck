import TDCore

public protocol BackofficeRepository {
    func validateVersion(_ version: String) async throws -> VersionPolicy
}
