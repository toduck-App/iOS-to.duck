public protocol FetchCategoriesUseCase {
    func execute() async throws -> [String]
}

public final class FetchCategoriesUseCaseImpl: FetchCategoriesUseCase {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [String] {
        return try await repository.fetchCategories()
    }
}
