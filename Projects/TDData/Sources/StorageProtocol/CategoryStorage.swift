import TDDomain

public protocol CategoryStorage {
    func fetchCategoryColors() async throws -> [TDCategoryDTO]
    func updateCategoryColors(colors: [TDCategoryDTO]) async throws
}
