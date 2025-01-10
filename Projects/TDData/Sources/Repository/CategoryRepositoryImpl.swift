import TDDomain

public final class CategoryRepositoryImpl: CategoryRepository {
    private let storage: CategoryStorage
    
    public init(storage: CategoryStorage) {
        self.storage = storage
    }
    
    public func fetchCategories() async throws -> [String] {
        try await storage.fetchCategoryColors()
    }
}
