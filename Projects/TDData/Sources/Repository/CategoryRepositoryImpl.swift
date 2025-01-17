import TDCore
import TDDomain

public final class CategoryRepositoryImpl: CategoryRepository {
    private let storage: CategoryStorage
    
    public init(storage: CategoryStorage) {
        self.storage = storage
    }
    
    public func fetchCategories() async throws -> [TDCategory] {
        try await storage.fetchCategories().map { $0.convertToTDCategory() }
    }
    
    public func updateCategories(categories: [TDCategory]) async throws -> Result<Void, TDDataError> {
        try await storage.updateCategories(categories: categories.map { TDCategoryDTO(from: $0) })
    }
}
