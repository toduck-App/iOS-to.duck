import TDDomain

public protocol CategoryStorage {
    func fetchCategoryColors() async throws -> [String]
    func updateCategoryColors(colors: [String]) async throws
}
