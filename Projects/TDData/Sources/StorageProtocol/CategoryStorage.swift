import TDCore
import TDDomain

public protocol CategoryStorage {
    func fetchCategories() async throws -> [TDCategoryDTO]
    func updateCategories(categories: [TDCategoryDTO]) async throws -> Result<Void, TDDataError>
}
