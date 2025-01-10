import Foundation

public protocol CategoryRepository {
    func fetchCategories() async throws -> [TDCategory]
}
