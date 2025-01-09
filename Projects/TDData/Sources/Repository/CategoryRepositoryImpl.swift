import TDDomain

public final class CategoryRepositoryImpl: CategoryRepository {
    public init() { }
    
    public func fetchCategories() async throws -> [String] {
        return ["#123456", "#345676", "#FF5733", "#33FF57"]
    }
}
