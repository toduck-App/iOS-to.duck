import TDCore
import TDDomain

final class MockCategoryRepository: CategoryRepository {
    var stubbedFetchCategoriesResult: [TDCategory] = []
    var stubbedFetchCategoriesError: TDDataError?

    var stubbedUpdateCategoriesResult: Result<Void, TDDataError> = .success(())
    var stubbedUpdateCategoriesError: TDDataError?

    var invokedUpdateCategories = false
    var invokedUpdateCategoriesParameters: [TDCategory]?

    func fetchCategories() async throws -> [TDCategory] {
        if let error = stubbedFetchCategoriesError {
            throw error
        }
        return stubbedFetchCategoriesResult
    }

    func updateCategories(categories: [TDCategory]) async throws -> Result<Void, TDDataError> {
        invokedUpdateCategories = true
        invokedUpdateCategoriesParameters = categories

        if let error = stubbedUpdateCategoriesError {
            throw error
        }
        return stubbedUpdateCategoriesResult
    }
}
