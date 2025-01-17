import TDCore
import TDDomain

final class MockCategoryRepository: CategoryRepository {
    var stubbedFetchCategoriesResult: [TDCategory] = []
    var stubbedFetchCategoriesError: TDDataError?

    func fetchCategories() async throws -> [TDCategory] {
        if let error = stubbedFetchCategoriesError {
            throw error
        }
        return stubbedFetchCategoriesResult
    }

    func updateCategories(categories: [TDCategory]) async throws -> Result<Void, TDDataError> {
        return .success(())
    }
}
