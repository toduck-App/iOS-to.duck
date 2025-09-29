import TDCore

public protocol ValidateVersionUseCase {
    func execute(_ version: String) async throws -> VersionPolicy
}

public final class ValidateVersionUseCaseImpl: ValidateVersionUseCase {
    private let repository: BackofficeRepository

    public init(repository: BackofficeRepository) {
        self.repository = repository
    }

    public func execute(_ version: String) async throws -> VersionPolicy {
        try await repository.validateVersion(version)
    }
}
