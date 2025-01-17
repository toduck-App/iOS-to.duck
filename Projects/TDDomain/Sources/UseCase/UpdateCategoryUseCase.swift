public protocol UpdateCategoriesUseCase {
    func execute(categories: [TDCategory]) async throws
}

public final class UpdateCategoriesUseCaseImpl: UpdateCategoriesUseCase {
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func execute(categories: [TDCategory]) async throws {
        try await repository.updateCategories(categories: categories).get()
    }
}
