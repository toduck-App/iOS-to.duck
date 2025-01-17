import TDCore

public protocol CategoryRepository {
    func fetchCategories() async throws -> [TDCategory]
    func updateCategories(categories: [TDCategory]) async throws -> Result<Void, TDDataError>
}
