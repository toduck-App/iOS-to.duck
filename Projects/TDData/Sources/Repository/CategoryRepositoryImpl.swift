import TDDomain

public final class CategoryRepositoryImpl: CategoryRepository {
    public init() { }
    
    public func fetchCategories() async throws -> [TDCategory] {
        return []
    }
}
