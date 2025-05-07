public protocol FetchCategoriesUseCase {
    func execute() async throws -> [TDCategory]
}

public final class FetchCategoriesUseCaseImpl: FetchCategoriesUseCase {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [TDCategory] {
        return try await repository.fetchCategories()
    }
}
